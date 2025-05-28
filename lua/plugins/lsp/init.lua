-- lua/plugins/lsp/init.lua
return {
  -- Podstawowa konfiguracja LSP
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Zarządzanie serwerami LSP, DAP, linterami, formatterami
      {
        'williamboman/mason.nvim',
        build = ':MasonUpdate', -- Upewnij się, że mason jest aktualny
        config = function()
          require('mason').setup({
            ui = {
              border = "rounded",
              icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
              }
            }
          })
        end,
      },
      -- Łącznik między mason a lspconfig
      'williamboman/mason-lspconfig.nvim',
      -- Dodatkowe źródła i ikonki dla cmp
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip', -- Silnik snippetów
      'saadparwaiz1/cmp_luasnip', -- Źródło snippetów dla cmp
      'rafamadriz/friendly-snippets', -- Kolekcja snippetów (opcjonalnie)
      'onsails/lspkind.nvim', -- Ikonki dla autouzupełniania LSP (opcjonalnie)
    },
    config = function()
      local lspconfig = require('lspconfig')
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local lspkind = require('lspkind') -- Opcjonalnie dla ikonek

      -- Załaduj snippety, np. z friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      -- Konfiguracja nvim-cmp (autouzupełnianie)
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(), -- lub <C-p>
          ['<C-j>'] = cmp.mapping.select_next_item(), -- lub <C-n>
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Akceptuj wybraną sugestię
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        -- Opcjonalnie: formatowanie z lspkind
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', -- Pokaż symbol i tekst
            maxwidth = 50,
            ellipsis_char = '...',
          })
        },
      })

      -- Konfiguracja mason-lspconfig
      -- To zapewni, że serwery LSP są instalowane przez Mason i konfigurowane przez lspconfig
      require('mason-lspconfig').setup({
        ensure_installed = { "clangd", "pyright", "lua_ls" }, -- Dodaj inne potrzebne serwery
        handlers = {
          -- Domyślny handler
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              on_attach = function(client, bufnr)
                -- Tutaj możesz zdefiniować skróty klawiszowe specyficzne dla LSP, np.:
                local map = function(mode, lhs, rhs, desc)
                  vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = "LSP: " .. desc })
                end
                map('n', 'K', vim.lsp.buf.hover, 'Hover')
                map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
                map('n', 'gD', vim.lsp.buf.declaration, 'Go to Declaration')
                map('n', 'gi', vim.lsp.buf.implementation, 'Go to Implementation')
                map('n', 'gr', vim.lsp.buf.references, 'Go to References')
                map('n', 'gt', vim.lsp.buf.type_definition, 'Type Definition')
                map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
                map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
                map('n', '<leader>ld', vim.diagnostic.open_float, 'Line Diagnostics')
                map('n', '[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
                map('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')

                -- Jeśli serwer wspiera formatowanie
                if client.supports_method("textDocument/formatting") then
                    map('n', '<leader>lf', function() vim.lsp.buf.format({ async = true }) end, 'Format Document')
                end
              end,
            })
          end,

          -- Specyficzna konfiguracja dla lua_ls (serwer Lua dla Neovim)
          ['lua_ls'] = function()
            lspconfig.lua_ls.setup({
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              settings = {
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = {'vim'} },
                  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                  telemetry = { enable = false },
                },
              },
              on_attach = function(client, bufnr)
                -- Skróty jak wyżej
                 local map = function(mode, lhs, rhs, desc)
                  vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = "LSP: " .. desc })
                end
                map('n', 'K', vim.lsp.buf.hover, 'Hover')
                map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
                map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code Action')
                map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')
              end,
            })
          end,

          -- Możesz dodać więcej specyficznych konfiguracji dla clangd lub pyright tutaj
          -- jeśli standardowa konfiguracja z pliku lua/plugins/lsp/settings/*.lua nie wystarcza
          -- lub jeśli wolisz trzymać je tutaj.

          ['pyright'] = function()
            -- Załaduj specyficzne ustawienia dla pyright
            local pyright_settings = require("plugins.lsp.settings.pyright")
            lspconfig.pyright.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                settings = pyright_settings,
                on_attach = function(client, bufnr)
                    -- Skróty
                end,
            })
          end,

          ['clangd'] = function()
            -- Załaduj specyficzne ustawienia dla clangd
            local clangd_settings = require("plugins.lsp.settings.clangd")
            lspconfig.clangd.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                cmd = clangd_settings.cmd, -- Przekaż polecenie cmd z ustawień
                filetypes = clangd_settings.filetypes,
                on_attach = function(client, bufnr)
                    -- Skróty
                end,
            })
          end,
        }
      })

      -- Konfiguracja diagnostyki (opcjonalnie, dla ładniejszych ikonek)
      vim.diagnostic.config({
        virtual_text = true, -- Pokaż diagnostykę w linii
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always", -- Pokaż źródło diagnostyki
        },
      })

      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
  },
}
