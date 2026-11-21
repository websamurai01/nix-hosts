local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Leader Keys
vim.keymap.set('n', '<leader>w', ':w<CR>')
vim.keymap.set('n', '<leader>q', ':q<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR> ')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

-- Center screen when jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Move lines up/down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Replace whole file with clipboard paste
vim.keymap.set('n', '<leader>v', 'ggVG"+p | :w<CR>', { desc = 'Paste clipboard to whole buffer' })

-- Copy entire buffer
vim.keymap.set('n', '<leader>y', 'ggVG"+y', { desc = 'Paste clipboard to whole buffer' })

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick file navigation
vim.keymap.set("n", "<leader>e", ":Oil<CR>", { desc = "Open file explorer" })
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

-- Quick config editing
vim.keymap.set("n", "<leader>rc", ":e $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":so $MYVIMRC<CR>", { desc = "Reload config" })

vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode", silent = true })

-- Copy Full File-Path
vim.keymap.set("n", "<leader>cfp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

-- Reload Configuration
vim.keymap.set("n", "<leader>rl", function()
  -- 1. Clear Lua Cache for your config modules
  for name,_ in pairs(package.loaded) do
    if name:match("^config") then
      package.loaded[name] = nil
    end
  end

  -- 2. Reload init.lua
  dofile(vim.env.MYVIMRC)
  
  -- 3. Re-source specific file if you are currently editing one
  if vim.fn.expand("%:e") == "lua" then
      pcall(dofile, vim.fn.expand("%"))
  end

  vim.notify("Configuration Reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Config" })
