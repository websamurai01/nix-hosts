--- System -----------------------------------------------------

-- powermenu
hl.bind (
  "CONTROL + ALT + Delete",
  hl.dsp.exec_cmd("powermenu") )

-- btop
hl.bind (
  "CONTROL + ALT + Insert",
  hl.dsp.exec_cmd(x.terminal .. " -e btop") )

-- close window safely
local safe_kill = require("scripts.safe-kill")
hl.bind (
  "SUPER + Q",
  safe_kill )

-- close window
hl.bind (
  "SUPER + SHIFT + Q",
  hl.dsp.window.close() )

-- toggle floating
hl.bind (
  "SUPER + SHIFT + E",
  hl.dsp.window.float({ action = "toggle" }) )

-- toggle fullscreen
hl.bind (
  "SUPER + Tab",
  hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }) )

-- drag/resize windows with lmb/rmb and dragging
hl.bind (
  "SUPER + mouse:272",
  hl.dsp.window.drag(),
  { mouse = true } )

hl.bind (
  "SUPER + mouse:273",
  hl.dsp.window.resize(),
  { mouse = true } )

--- x ----------------------------------------------------------

hl.bind (
  "SUPER + Return",
  hl.dsp.exec_cmd(x.terminal) )

hl.bind (
  "SUPER + D",
  hl.dsp.exec_cmd(x.menu) )

hl.bind (
  "SUPER + E",
  hl.dsp.exec_cmd(x.file_manager) )

hl.bind (
  "SUPER + B",
  hl.dsp.exec_cmd(x.browser) )

-- screenshots
local screenshot = require("scripts.screenshot")

hl.bind (
  "SUPER + P",
  function() screenshot("region") end )

hl.bind (
  "SUPER + O",
  hl.dsp.exec_cmd("hyprpicker -a | wl-copy") )

--- Workspaces -------------------------------------------------

for i = 1, 6 do
  hl.bind (
    "ALT + " .. i,
    hl.dsp.focus({ workspace = tostring(i) }) )

  hl.bind (
    "ALT + SHIFT + " .. i,
    hl.dsp.window.move({ workspace = tostring(i) }) )
end
