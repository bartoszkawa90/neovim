-- lua/plugins/lsp/settings/pyright.lua
-- Ustawienia specyficzne dla serwera Pyright
return {
  python = {
    pythonPath = vim.fn.exepath('python3') or "python3", -- Lub ścieżka do Twojego interpretera Python
    analysis = {
      typeCheckingMode = "basic", -- lub "off", "strict"
      useLibraryCodeForTypes = true,
      autoSearchPaths = true,
      diagnosticMode = "workspace", -- "openFilesOnly" lub "workspace"
      -- Możesz dodać ścieżki do stubów, jeśli to konieczne
      -- stubPath = "/path/to/your/stubs"
    },
  },
}
