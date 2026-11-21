-- Theme
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- No Syntax / No Highlighting
vim.cmd("syntax off")
vim.opt.syntax = "off"

-- Directories (Notes & Undo)
local notes_dir = vim.fn.expand("~/Documents/Notes")
if vim.fn.isdirectory(notes_dir) == 0 then vim.fn.mkdir(notes_dir, "p") end
vim.api.nvim_set_current_dir(notes_dir)

local undo_dir = notes_dir .. "/.undo"
if vim.fn.isdirectory(undo_dir) == 0 then vim.fn.mkdir(undo_dir, "p") end
vim.opt.undodir = undo_dir
vim.opt.undofile = true

-- Zen Visuals
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.signcolumn = "no"
vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.opt.cursorline = false
vim.opt.fillchars = { eob = "~" }

-- Typewriter Behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakat = " \t"
vim.opt.breakindent = true
vim.opt.textwidth = 0
vim.opt.autoindent = true
vim.opt.smartindent = false
vim.opt.expandtab = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 0

-- System
vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.updatetime = 500

vim.opt.winborder = "rounded"
vim.opt.showtabline = 0

vim.opt.encoding = "UTF-8"

-- Command-line Completion
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- Better Diff Options
vim.opt.diffopt:append("linematch:60")

-- Performance Improvements
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- Custom Status Line
vim.opt.statusline = "  %f [%y] %m %= %{wordcount().words} words  "
