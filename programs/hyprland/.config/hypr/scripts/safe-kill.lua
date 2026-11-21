-- Safe Kill

local STEAM_GAME_CLASS_PATTERN = "^steam_app_"

return function()
  local active = hl.get_active_window()
  if not active then return end

  if string.match(active.initial_class or "", STEAM_GAME_CLASS_PATTERN) then
    return
  end

  hl.dispatch(hl.dsp.window.close())
end
