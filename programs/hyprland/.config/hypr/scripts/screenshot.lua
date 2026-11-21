-- Screenshot

return function(mode)
  local dir = os.getenv("HOME") .. "/Pictures/Screenshots"
  os.execute("mkdir -p " .. dir)
  local timestamp = os.date("%Y%m%d-%H%M%S")
  local filename
  if mode == "window" then
    local active = hl.get_active_window()
    local class = "active-window"
    if active and active.class and active.class ~= "" then
      class = string.gsub(active.class, "[^a-zA-Z0-9]", "_")
    end
    filename = timestamp .. "-" .. class .. ".png"
  elseif mode == "output" then
    filename = timestamp .. "-fullscreen.png"
  else
    filename = timestamp .. "-region.png"
  end
  local cmd = "hyprshot --freeze -m " .. mode .. " -o " .. dir .. " -f " .. filename
  hl.dispatch(hl.dsp.exec_cmd(cmd))
end
