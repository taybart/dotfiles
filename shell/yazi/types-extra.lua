-- Supplementary LuaCATS type stubs for Yazi's UI layout components.
--
-- The official `types.yazi` package (yazi-rs/plugins:types) covers the core API
-- (`ya`, `cx`, `ui`, `fs`, `ps`, `rt`, `th`, `Url`, `Command`, `File`, `Cha`),
-- but it does NOT include the layout component globals that `init.lua` touches
-- (`Header`, `Status`, `Manager`, `Tasks`, `Linemode`, ...).
--
-- These globals are injected by Yazi at runtime, so LuaLS otherwise reports them
-- as `undefined-global`. This file silences that warning and provides
-- autocomplete for the `children_add` / `children_remove` methods and the
-- area constants (`LEFT`, `RIGHT`, `CENTER`, `TOP`, `BOTTOM`).
--
-- Add this file to `workspace.library` in `.luarc.json` to enable it.

---@alias YaziArea integer

---@class YaziComponent
---@field children_add fun(self: YaziComponent, fn: fun(): unknown, order: integer, side?: YaziArea): integer
---@field children_remove fun(self: YaziComponent, id: integer, side?: YaziArea)
---@field LEFT YaziArea
---@field RIGHT YaziArea
---@field CENTER YaziArea
---@field TOP YaziArea
---@field BOTTOM YaziArea

---@type YaziComponent
Header = {}

---@type YaziComponent
Status = {}

---@type YaziComponent
Manager = {}

---@type YaziComponent
Tasks = {}

---@type YaziComponent
Linemode = {}

---@type YaziComponent
Select = {}

---@type YaziComponent
Input = {}

---@type YaziComponent
Confirm = {}

---@type YaziComponent
Help = {}

---@type YaziComponent
Folder = {}

---@type YaziComponent
Preview = {}

---@type YaziComponent
Bar = {}

---@type YaziComponent
which = {}
