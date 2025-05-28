-- lua/config/options.lua

local opt = vim.opt -- dla czytelności

-- Podstawowe
opt.mouse = "a"                 -- Włącz obsługę myszy we wszystkich trybach
opt.clipboard = "unnamedplus"   -- Używaj systemowego schowka
opt.swapfile = false            -- Wyłącz pliki wymiany
opt.backup = false              -- Wyłącz pliki kopii zapasowych
opt.undofile = true             -- Włącz trwałe cofanie zmian

-- Zdefiniuj ścieżkę do katalogu undodir w lokalnej zmiennej
local undodir_path = vim.fn.stdpath("data") .. "/undodir"

-- Ustaw opcję Neovim 'undodir'
opt.undodir = undodir_path

-- Utwórz katalog, używając zmiennej przechowującej ciąg znaków
-- Sprawdź najpierw, czy katalog nie istnieje, aby uniknąć błędu, jeśli już istnieje
if vim.fn.isdirectory(undodir_path) == 0 then
  vim.fn.mkdir(undodir_path, "p")  -- Utwórz katalog, jeśli nie istnieje
end

-- Wygląd
opt.number = true               -- Pokaż numery linii
opt.relativenumber = true       -- Pokaż relatywne numery linii
opt.termguicolors = true        -- Włącz prawdziwe kolory w terminalu (ważne dla motywów)
opt.signcolumn = "yes"          -- Zawsze pokazuj kolumnę znaków (dla LSP, GitSigns itp.)
opt.scrolloff = 8               -- Minimalna liczba linii widocznych powyżej/poniżej kursora
opt.sidescrolloff = 8
opt.wrap = false                -- Wyłącz zawijanie linii

-- Wcięcia
opt.tabstop = 4                 -- Liczba spacji dla tabulatora
opt.softtabstop = 4             -- Liczba spacji dla edycji z tabulatorem
opt.shiftwidth = 4              -- Liczba spacji dla auto-wcięcia
opt.expandtab = true            -- Używaj spacji zamiast tabulatorów
opt.smartindent = true          -- Inteligentne auto-wcięcia
opt.autoindent = true

-- Wyszukiwanie
opt.hlsearch = true             -- Podświetl wyniki wyszukiwania
opt.incsearch = true            -- Pokazuj wyniki wyszukiwania na bieżąco
opt.ignorecase = true           -- Ignoruj wielkość liter przy wyszukiwaniu
opt.smartcase = true            -- Jeśli wzorzec zawiera duże litery, wyszukuj z uwzględnieniem wielkości

-- Inne
opt.completeopt = "menuone,noselect" -- Opcje autouzupełniania
opt.shortmess:append "c"        -- Nie pokazuj wiadomości "match xxx of yyy"
opt.hidden = true               -- Pozwól na ukrywanie buforów bez zapisu

vim.cmd "colorscheme habamax" -- Domyślny schemat kolorów, jeśli nie masz motywu