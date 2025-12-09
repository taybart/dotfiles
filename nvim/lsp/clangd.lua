return {
  -- remove "proto" for now since i use protobuf more
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  cmd = { 'clangd', '--background-index', '--query-driver=**' },
}
