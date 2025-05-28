-- lua/plugins/statusline.lua
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      options = {
        theme = 'auto', -- Lub nazwa motywu, np. 'catppuccin' jeśli używasz
        icons_enabled = true,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        -- Inne opcje lualine
      },
      sections = {
        lualine_c = {
            {
                'filename',
                path = 1, -- 0: just filename, 1: relative path, 2: absolute path
            }
        },
        -- Inne sekcje
      }
    }
  end,
}