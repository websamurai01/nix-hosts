return {
  'rebelot/kanagawa.nvim',
  -- Set priority to ensure it loads before other plugins that rely on colors
  priority = 1000, 
  -- Set lazy = false to load it immediately on startup
  lazy = false, 
  config = function()
    -- 1. Setup/Configure Kanagawa (Optional)
    require('kanagawa').setup({
      -- Customize your preferred variant (wave, dragon, or lotus)
      theme = 'wave', 
      
      -- Common Customizations:
      transparent = true, -- Set to true for a transparent background
      background = {
        dark = 'dragon',   -- Use 'dragon' variant for dark mode
        light = 'lotus',   -- Use 'lotus' variant for light mode
      },
      
      -- Overrides are for customizing specific highlight groups
      overrides = function(colors) 
        local theme = colors.theme
        return {
          -- Example: Remove the background for line numbers and sign column
          LineNr = { fg = theme.ui.fg_dim, bg = 'none' },
          SignColumn = { bg = 'none' },
        }
      end,
      -- ... other configuration options ...
    })

    -- 2. Load the colorscheme
    -- This command must be run after the plugin is set up.
    vim.cmd("colorscheme kanagawa")
  end
}
