-- lua/plugins/treesitter.lua
return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        "c", "cpp", "python", "lua", "vim", "vimdoc", "query",
        "bash", "html", "javascript", "json", "markdown", "yaml", "css", "go"
      },
      sync_install = false, -- Instaluj parsery asynchronicznie
      auto_install = true,  -- Automatycznie instaluj brakujące parsery
      highlight = {
        enable = true,
        -- additional_vim_regex_highlighting = false, -- Wyłącz dodatkowe podświetlanie regex (może spowalniać)
      },
      indent = { enable = true },
      -- Inne moduły treesitter, np. incremental_selection, textobjects itp.
      -- rainbow = { enable = true, extended_mode = true, max_file_lines = nil } -- nvim-ts-rainbow
    }
  end,
}