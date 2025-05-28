-- lua/plugins/theme.lua
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Upewnij się, że ładuje się wcześnie
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      -- Inne opcje konfiguracyjne Catppuccin
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = true,
        -- Inne integracje
        dap = {
          enabled = true,
          enable_ui = true, -- Requires nvim-dap-ui
        },
      },
    })
    vim.cmd.colorscheme "catppuccin"
  end,
}



-- -- lua/plugins/theme.lua
-- return {
--   "navarasu/onedark.nvim",
--   name = "onedark",
--   priority = 1000, -- Ensures the theme is loaded early
--   config = function()
--     require("onedark").setup({
--       style = "dark", -- Change this to "cool", "deep", or "warm" if desired
--       -- Other onedark-specific configuration options can be added here
--     })
--     require("onedark").load()
--   end,
-- }



