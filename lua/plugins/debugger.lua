-- lua/plugins/debugger.lua
return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          local dapui = require('dapui')
          dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = {
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
            },
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.33 },
                  { id = "breakpoints", size = 0.17 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 0.33, -- Procent szerokości ekranu
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 0.25, -- Procent wysokości ekranu
                position = "bottom",
              },
            },
            floating = {
              max_height = nil, -- Maksymalna wysokość (nil dla automatycznego dopasowania)
              max_width = nil,  -- Maksymalna szerokość (nil dla automatycznego dopasowania)
              border = "rounded",
            },
            render = {
              max_type_length = nil, -- Maksymalna długość typu (nil dla pełnej długości)
            }
          })
        end
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
        -- Upewnij się, że mason-nvim-dap ładuje się po mason.nvim
        dependencies = { 'williamboman/mason.nvim' },
        -- Konfiguracja mason-nvim-dap
        config = function()
            require('mason-nvim-dap').setup({
                ensure_installed = { "codelldb", "python" }, -- Adaptery DAP do zainstalowania
                -- Automatyczna konfiguracja adapterów
                automatic_installation = true,
                handlers = {}, -- Pozostaw puste dla domyślnych handlerów lub dodaj własne
            })
        end,
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Skróty klawiszowe DAP
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'DAP: Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'DAP: Set Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'DAP: Continue' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'DAP: Step Over' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'DAP: Step Into' })
      vim.keymap.set('n', '<leader>du', dap.step_out, { desc = 'DAP: Step Out' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'DAP: Open REPL' })
      vim.keymap.set('n', '<leader>dl', function() dap.run_last() end, { desc = 'DAP: Run Last' })
      vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'DAP: Terminate' })
      vim.keymap.set('n', '<leader>dw', dapui.toggle, { desc = 'DAP: Toggle UI' })


      -- Konfiguracja adaptera C++ (codelldb) - mason-nvim-dap powinien to obsłużyć
      -- Jeśli nie, możesz dodać ręcznie:
      -- dap.adapters.codelldb = { ... }
      dap.configurations.cpp = {
        {
          name = "Launch C++ (codelldb)",
          type = "codelldb", -- Musi pasować do nazwy adaptera zainstalowanego przez mason-nvim-dap
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          runInTerminal = false, -- Użyj zintegrowanej konsoli DAP
        },
      }
      -- Możesz używać tej samej konfiguracji dla C
      dap.configurations.c = dap.configurations.cpp

      -- Konfiguracja adaptera Python (debugpy) - mason-nvim-dap powinien to obsłużyć
      dap.configurations.python = {
        {
          type = 'python', -- Musi pasować do nazwy adaptera zainstalowanego przez mason-nvim-dap ('python' dla debugpy)
          request = 'launch',
          name = 'Launch Python file',
          program = '${file}', -- Uruchamia bieżący plik
          pythonPath = function()
             -- Spróbuj znaleźć aktywne venv, jeśli nie, użyj systemowego pythona
            local venv = os.getenv("VIRTUAL_ENV")
            if venv and venv ~= "" then
                return venv .. "/bin/python"
            end
            return vim.fn.exepath('python3') or 'python3'
          end,
          -- Możesz dodać więcej opcji, np. args, console, itp.
        },
      }

      -- Automatyczne otwieranie/zamykanie UI DAP
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end
  },
}