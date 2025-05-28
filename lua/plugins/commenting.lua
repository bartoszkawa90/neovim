-- lua/plugins/commenting.lua
return {
  'numToStr/Comment.nvim',
  event = "BufReadPre", -- lub "VeryLazy"
  config = function()
    require('Comment').setup({
      -- Możesz dodać konfigurację specyficzną dla języków, jeśli potrzebujesz
      -- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
  end,
}
-- Jeśli używasz 'ts_context_commentstring' dla lepszego komentowania w JSX/TSX:
-- dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' }