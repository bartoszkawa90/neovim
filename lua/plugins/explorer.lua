-- lua/plugins/explorer.lua
return {
  "nvim-tree/nvim-tree.lua",
  version = "*", -- lub konkretny tag
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("nvim-tree").setup({
      sort_by = "name",
      view = {
        width = 30,
        side = "left",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
      },
      filters = {
        dotfiles = false, -- Pokaż pliki ukryte
        custom = { ".git", "node_modules", ".cache" },
      },
      git = {
        enable = true,
        ignore = false,
      },
      -- Inne opcje...
    })
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })
    vim.keymap.set('n', '<leader>of', ':NvimTreeFindFile<CR>', { desc = 'Open File in NvimTree and Focus'})
  end,
}