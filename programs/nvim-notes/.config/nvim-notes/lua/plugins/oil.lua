return {
  "stevearc/oil.nvim",
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    columns = {
      "icon",
    },
    view_options = {
      show_hidden = false,
      sort = {
        { "name", "desc" },
      },
    },
    -- Use a floating window for the file explorer
    float = {
      padding = 5,
      max_width = 90,
      max_height = 42,
      border = "rounded",
    },
    keymaps = {
      ["q"] = "actions.close",
      ["<CR>"] = "actions.select",
    },
  },
}
