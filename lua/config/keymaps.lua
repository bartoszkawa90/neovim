-- lua/config/keymaps.lua

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Podstawowe nawigacyjne
keymap("n", "<C-h>", "<C-w>h", opts) -- Przejdź do okna po lewej
keymap("n", "<C-j>", "<C-w>j", opts) -- Przejdź do okna poniżej
keymap("n", "<C-k>", "<C-w>k", opts) -- Przejdź do okna powyżej
keymap("n", "<C-l>", "<C-w>l", opts) -- Przejdź do okna po prawej

-- Zmiana rozmiaru okien
keymap("n", "<leader>rh", ":vertical resize -2<CR>", opts)
keymap("n", "<leader>rl", ":vertical resize +2<CR>", opts)
keymap("n", "<leader>rk", ":resize -2<CR>", opts)
keymap("n", "<leader>rj", ":resize +2<CR>", opts)


-- Zarządzanie buforami
keymap("n", "<leader>bn", ":bnext<CR>", opts)       -- Następny bufor
keymap("n", "<leader>bp", ":bprevious<CR>", opts)   -- Poprzedni bufor
keymap("n", "<leader>bd", ":bdelete<CR>", opts)     -- Zamknij bufor
keymap("n", "<leader>bQ", ":bufdo bdelete<CR>", opts) -- Zamknij wszystkie bufory oprócz aktywnego

-- Zapis i wyjście
keymap("n", "<leader>w", ":w<CR>", opts)    -- Zapisz
keymap("n", "<leader>q", ":q<CR>", opts)    -- Wyjdź
keymap("n", "<leader>wq", ":wq<CR>", opts)  -- Zapisz i wyjdź

-- Wklejanie bez nadpisywania rejestru
keymap("v", "p", '"_dP', opts)

-- Inne przydatne
keymap("n", "<Esc>", ":noh<CR>", opts) -- Wyłącz podświetlanie wyszukiwania