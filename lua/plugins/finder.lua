-- lua/plugins/finder.lua
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.x', -- Lub najnowszy stabilny tag
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- Opcjonalnie: telescope-fzf-native.nvim dla szybszego sortowania
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' , cond = vim.fn.executable("make") == 1 }
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup {
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<esc>"] = actions.close,
          },
        },
        -- Inne domyślne ustawienia Telescope
      },
      pickers = {
        -- Domyślne ustawienia dla konkretnych pickerów
      },
      extensions = {
        fzf = {
          fuzzy = true,                    -- Włącz fuzzy matching
          override_generic_sorter = true,  -- Nadpisz domyślny sorter
          override_file_sorter = true,     -- Nadpisz sorter plików
          case_mode = "smart_case",        -- "smart_case", "ignore_case", "respect_case"
        }
      }
    }

    -- Załaduj rozszerzenie fzf jeśli jest
    pcall(telescope.load_extension, "fzf")

    -- Skróty klawiszowe
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Find Old Files (History)'})
  end,
}