-- lua/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup -- Create a helper function for augroups
local MyAutoCmds = augroup("MyAutoCmds", { clear = true }) -- Create a new augroup or clear it if it exists

local autocmd = vim.api.nvim_create_autocmd -- Helper for creating autocommands

-- 1. Highlight on yank (copy)
--    Briefly flashes the text that was just copied.
autocmd("TextYankPost", {
  group = MyAutoCmds,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Highlight yanked text",
})

-- 2. Restore cursor position
--    When you open a file, jump to the last known cursor position.
autocmd("BufReadPost", {
  group = MyAutoCmds,
  pattern = "*",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count and not vim.b[args.buf].is_large_file then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
  desc = "Restore cursor position on opening a file",
})

-- 3. Auto-resize splits on Neovim resize
--    Ensures that window splits resize proportionally when the Neovim window itself is resized.
autocmd("VimResized", {
  group = MyAutoCmds,
  pattern = "*",
  command = "wincmd =",
  desc = "Auto-resize splits on Neovim resize",
})

-- 4. Consistent Markdown list indentation and continuation
--    Automatically continues markdown list markers and indents correctly.
autocmd("FileType", {
  group = MyAutoCmds,
  pattern = "markdown",
  callback = function()
    vim.opt_local.formatoptions:append { "t", "c", "r", "o" }
    -- "t" - auto-wrap text using textwidth
    -- "c" - auto-wrap comments using textwidth, and auto-indent new lines
    -- "r" - automatically insert the current comment leader after hitting enter in insert mode
    -- "o" - automatically insert the current comment leader after hitting 'o' or 'O' in normal mode
    vim.opt_local.textwidth = 80 -- Or your preferred text width for markdown
  end,
  desc = "Set options for Markdown files",
})

-- 5. Automatically toggle relative numbers based on focus
--    Shows relative line numbers in focused windows and absolute line numbers in unfocused windows.
-- autocmd({"FocusGained", "BufEnter", "WinEnter"}, {
--   group = MyAutoCmds,
--   pattern = "*",
--   callback = function()
--     if vim.o.number and vim.o.relativenumber == false then
--       vim.opt.relativenumber = true
--     end
--   end,
--   desc = "Enable relative numbers for focused window"
-- })

-- autocmd({"FocusLost", "BufLeave", "WinLeave"}, {
--   group = MyAutoCmds,
--   pattern = "*",
--   callback = function()
--     if vim.o.number and vim.o.relativenumber then
--       vim.opt.relativenumber = false
--     end
--   end,
--   desc = "Disable relative numbers for unfocused window"
-- })
-- Note: The relative number toggle might feel a bit "jumpy" for some. Keep if you like it.

-- 6. Close some filetypes with 'q' (e.g., help, man, qf list)
autocmd("FileType", {
  group = MyAutoCmds,
  pattern = {
    "help",       -- Vim help pages
    "man",        -- Man pages
    "qf",         -- Quickfix list
    "lspinfo",    -- LSP info window
    "spectre_panel", -- If you use the spectre plugin
    "lir",        -- If you use a file explorer like lir
    "fern",       -- If you use fern file explorer
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { silent = true, buffer = args.buf })
  end,
  desc = "Close certain filetypes with 'q'",
})

-- Remember to require this file in your init.lua if you haven't already:
-- At the top of init.lua, or after setting up lazy.nvim but before `lazy.setup({})`:
-- require("config.autocmds")
-- (You actually already have this line in the init.lua I provided earlier, under "Załaduj konfiguracje podstawowe")