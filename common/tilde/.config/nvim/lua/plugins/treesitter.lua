return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" }, -- Load lazily when opening a file
  config = function()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
      -- A list of parser names, or "all"
      ensure_installed = { 
        "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "html", "css", "json" 
      },
      
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      highlight = {
        enable = true, -- mandatory
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
}
