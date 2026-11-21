local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- File Viewer (Oil)
vim.keymap.set("n", "<leader>e", function() require("oil").open_float() end, { desc = "Open File List" })

-- New Note (Empty Buffer)
vim.keymap.set("n", "<leader>n", ":enew | ZenMode | ZenMode<CR>", { desc = "New Note" })

-- Manual Save
vim.keymap.set("n", "<leader>s", function()
  _G.UpdateMetadata()
  _G.Rename()
  -- vim.cmd("w!")
end, { desc = "Rename & Save" })

-- Quit All
vim.keymap.set("n", "ZZ", function()
  _G.UpdateMetadata()
  _G.Rename()
  vim.cmd("wqa!")
end, { desc = "Rename & Save & Quit All" })

vim.keymap.set("n", "ZQ", ":qa!<CR>", { desc = "Quit All No Save" })

-- Navigation
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true })
vim.keymap.set({ 'n', 'v' }, '0', 'g0', { silent = true })
vim.keymap.set({ 'n', 'v' }, '$', 'g$', { silent = true })
vim.keymap.set({ "n", "v" }, "<Down>", "gj", { silent = true })
vim.keymap.set({ "n", "v" }, "<Up>", "gk", { silent = true })
vim.keymap.set("i", "<Down>", "<C-o>gj", { silent = true })
vim.keymap.set("i", "<Up>", "<C-o>gk", { silent = true })

-- Improved gf to handle relative paths
vim.keymap.set('n', 'gf', function()
  vim.cmd('lcd %:h')
  vim.cmd('normal! gf')
end, { noremap = true, silent = true, desc = 'Go to file (relative to current file)' })

-- Timestamp
vim.keymap.set('i', '<C-t>', function() return os.date("%Y-%m-%d %H:%M") end, { expr = true })

-- Center Screen When Jumping
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Better Indenting in Visual Mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Quick Config Editing
vim.keymap.set("n", "<leader>rc", ":e $MYVIMRC<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>rl", ":so $MYVIMRC<CR>", { desc = "Reload config" })

vim.keymap.set("n", "<leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode", silent = true })

-- Copy Full File-Path
vim.keymap.set("n", "<leader>pa", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end)

