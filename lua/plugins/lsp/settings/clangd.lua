-- lua/plugins/lsp/settings/clangd.lua
-- Ustawienia specyficzne dla serwera clangd
return {
  cmd = {
    "clangd",
    "--background-index",
    "--pch-storage=memory",
    "--clang-tidy",
    "--completion-style=detailed",
    "--header-insertion=iwyu", -- "include what you use"
    "--fallback-style=llvm" -- Styl formatowania, jeśli nie ma .clang-format
    -- "--compile-commands-dir=build", -- Możesz ustawić domyślną ścieżkę do compile_commands.json
                                   -- Lepiej jednak, gdy clangd sam ją wykryje
  },
  filetypes = {"c", "cpp", "objc", "objcpp", "cuda"},
  -- root_dir = function(fname)
  --   return require'lspconfig'.util.root_pattern(
  --       'compile_commands.json',
  --       'compile_flags.txt',
  --       '.git'
  --   )(fname) or vim.fn.getcwd()
  -- end,
}
