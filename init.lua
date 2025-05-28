-- init.lua

-- Ustawienie globalnego lidera (musi być przed pierwszym użyciem <leader>)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Instalacja i konfiguracja lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Załaduj konfiguracje podstawowe (opcje, skróty)
require("config.options")
require("config.keymaps")
-- require("config.autocmds") -- Jeśli zdecydujesz się używać

-- Konfiguracja wtyczek z katalogu lua/plugins/
-- lazy.nvim automatycznie wykryje pliki .lua w 'plugins'
-- i potraktuje je jako specyfikacje wtyczek
require("lazy").setup({
  spec = {
    -- Automatycznie ładuj wszystkie pliki .lua z lua/plugins/
    { import = "plugins" },
    -- Możesz również importować specyficzne podkatalogi, jeśli są
    { import = "plugins.lsp" }, -- Jeśli masz plik lua/plugins/lsp.lua lub lua/plugins/lsp/init.lua
  },
  -- Opcjonalne ustawienia lazy.nvim
  checker = {
    enabled = true, -- Sprawdzaj aktualizacje wtyczek
    notify = true,
  },
  change_detection = {
    enabled = true,
    notify = true, -- Powiadamiaj, gdy wykryje zmiany w plikach konfiguracyjnych
  }
})