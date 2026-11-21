-- Dump the current buffer to stdout with ANSI 24-bit colors, using the
-- buffer's tree-sitter grammar plus any injected languages (code blocks in
-- markdown, <script> in html, ...). Parses synchronously; no highlighter.
-- Loaded with: nvim --headless -c "luafile dump.lua" <file>
--
-- Exit codes: 0 = highlighted output written, 3 = no tree-sitter parser or
-- highlights query for this file (caller should fall back), 1 = error.

local EXIT_UNSUPPORTED = 3

local buf = vim.api.nvim_get_current_buf()

-- Captures that carry no color (spell checking, concealing, private "_x").
local non_hl = { spell = true, nospell = true, conceal = true, conceal_lines = true }

-- Resolve a highlight group name ("@keyword.modifier") to its effective
-- attributes, walking up the "@capture.sub" hierarchy and following links.
-- Misses are cached as false.
local cache = {}
local function resolve(group)
  local hit = cache[group]
  if hit ~= nil then return hit or nil end
  local name = group
  for _ = 1, 16 do
    local ok, h = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and h and (h.fg or h.bg or h.bold or h.italic) then
      local r = { fg = h.fg, bg = h.bg, bold = h.bold, italic = h.italic }
      cache[group] = r
      return r
    end
    local i = name:find('%.[^%.]+$') -- strip the last ".segment"
    if not i then break end
    name = name:sub(1, i - 1)
  end
  cache[group] = false
  return nil
end

local function rgb(n, prefix)
  return string.format('\27[%d;2;%d;%d;%dm', prefix, (n >> 16) & 0xff, (n >> 8) & 0xff, n & 0xff)
end

-- ANSI sequence for a group, or nil for default color.
local function sgr(group)
  local h = resolve(group)
  if not h then return nil end
  local s = ''
  if h.fg then s = s .. rgb(h.fg, 38) end
  if h.bg then s = s .. rgb(h.bg, 48) end
  if h.bold then s = s .. '\27[1m' end
  if h.italic then s = s .. '\27[3m' end
  return s
end

-- Parse the buffer (with injections) or return nil if unsupported.
local function parse()
  local ft = vim.bo[buf].filetype
  if ft == '' then return nil end
  local lang = vim.treesitter.language.get_lang(ft) or ft
  local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
  if not ok or not parser then return nil end
  local qok, query = pcall(vim.treesitter.query.get, lang, 'highlights')
  if not qok or not query then return nil end
  parser:parse(true) -- true = also parse injected languages
  return parser
end

-- rows[row] = list of { c1, c2 (nil = to EOL), group, prio }, in the order
-- nvim's highlighter would apply them: parent tree before injected trees,
-- captures in iteration order. Higher `priority` metadata wins; at equal
-- priority the later capture (inner node / later pattern / injection) wins.
local function collect(parser)
  local rows = {}
  local default_prio = vim.hl.priorities.treesitter
  parser:for_each_tree(function(tstree, ltree)
    local qok, query = pcall(vim.treesitter.query.get, ltree:lang(), 'highlights')
    if not qok or not query then return end
    for id, node, metadata in query:iter_captures(tstree:root(), buf, 0, -1) do
      local cap = query.captures[id]
      if not non_hl[cap] and cap:sub(1, 1) ~= '_' then
        local r1, c1, r2, c2 = node:range()
        local prio = tonumber(metadata.priority or (metadata[id] and metadata[id].priority))
          or default_prio
        local group = '@' .. cap .. '.' .. ltree:lang() -- e.g. @string.lua
        for r = r1, r2 do
          rows[r] = rows[r] or {}
          rows[r][#rows[r] + 1] = {
            c1 = (r == r1) and c1 or 0,
            c2 = (r == r2) and c2 or nil,
            group = group,
            prio = prio,
          }
        end
      end
    end
  end)
  return rows
end

local function render(lines, rows)
  local out = {}
  for row = 0, #lines - 1 do
    local line = lines[row + 1]
    local marks = rows[row]
    if not marks then
      out[#out + 1] = line
    else
      local len = #line
      local cell = {}
      for _, m in ipairs(marks) do
        for c = m.c1, (m.c2 or len) - 1 do
          local prev = cell[c]
          if not prev or m.prio >= prev.prio then cell[c] = m end
        end
      end

      local parts, cur, start = {}, nil, 0
      local function flush(upto)
        if upto <= start then return end
        local text = line:sub(start + 1, upto)
        local code = cur and sgr(cur)
        parts[#parts + 1] = code and (code .. text .. '\27[0m') or text
      end
      for c = 0, len - 1 do
        local g = cell[c] and cell[c].group
        if g ~= cur then
          flush(c)
          cur, start = g, c
        end
      end
      flush(len)
      out[#out + 1] = table.concat(parts)
    end
  end
  return out
end

local ok, err = pcall(function()
  local parser = parse()
  if not parser then
    vim.cmd('cq ' .. EXIT_UNSUPPORTED)
    return
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  io.stdout:write(table.concat(render(lines, collect(parser)), '\n') .. '\n')
  io.stdout:flush()
end)

if not ok then
  io.stderr:write('nvim-preview: ' .. tostring(err) .. '\n')
  vim.cmd('cq 1')
end
vim.cmd('qa!')
