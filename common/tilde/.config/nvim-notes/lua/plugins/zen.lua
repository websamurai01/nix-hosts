return {
  "folke/zen-mode.nvim",
  lazy = false, -- Load immediately (for Auto-Start)
  opts = {
    window = {
      width = 75,
      height = 0.90,
      backdrop = 1, -- Solid background
      options = {
        signcolumn = "yes",
        number = false,
        relativenumber = false,
        cursorline = false,
        foldcolumn = "0",
        wrap = true,
        linebreak = true,
        breakindent = true,
        fillchars = "eob:~",
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
        laststatus = 3, -- 3 = Global Status Line (recommended), 2 = Standard
      },
      twilight = { enabled = false },
    },
    on_open = function()
      -- Invisible Padding
      vim.cmd("hi! link ZenBg Normal")
      vim.cmd("hi! link ZenBgNC Normal")
    end,
  },
  config = function(_, opts)
    require("zen-mode").setup(opts)
    -- Auto-Start Logic
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        vim.defer_fn(function() require("zen-mode").toggle() end, 0)
      end,
    })
  end,
}
