hl.config ({
  general = {
    layout = "dwindle",
    gaps_in = 0,
    gaps_out = 0,
    border_size = 0,
    resize_on_border = false,
    allow_tearing = false,
  },

  scrolling = {
    fullscreen_on_one_column = false,
    column_width = 0.7,
    focus_fit_method = 0,
    follow_focus = 1,
  },

  decoration = {
    rounding = 0,
  },

  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },
})

-- Animations

hl.curve ( "steep", {
  type = "bezier",
  points = { {0, 1}, {0, 1} }
})

hl.curve ( "ease_out_quint", {
  type = "bezier",
  points = { {0.23, 1}, {0.32, 1} }
})

hl.curve ( "ease_in_out_cubic", {
  type = "bezier",
  points = { {0.65, 0.05}, {0.36, 1} }
})

hl.curve ( "almost_linear", {
  type = "bezier",
  points = { {0.5, 0.5}, {0.75, 1} }
})

hl.animation ({
  leaf = "workspaces",
  enabled = false,
})

hl.animation ({
  leaf = "specialWorkspace",
  enabled = false,
})

hl.animation ({
  leaf = "windows",
  enabled = true,
  speed = 4,
  bezier = "ease_out_quint",
  style = "slide",
})

hl.animation ({
  leaf = "windowsIn",
  enabled = true,
  speed = 4,
  bezier = "ease_out_quint",
})

hl.animation ({
  leaf = "windowsOut",
  enabled = true,
  speed = 4,
  bezier = "ease_out_quint",
})

hl.animation ({
  leaf = "fade",
  enabled = true,
  speed = 0.5,
  bezier = "almost_linear",
})

hl.animation ({
  leaf = "layers",
  enabled = false,
  speed = 1,
  bezier = "ease_out_quint",
})

hl.animation ({
  leaf = "layersIn",
  enabled = true,
  speed = 0.2,
  bezier = "steep",
  style = "fade",
})

hl.animation ({
  leaf = "layersOut",
  enabled = true,
  speed = 0.2,
  bezier = "steep",
  style = "fade",
})
