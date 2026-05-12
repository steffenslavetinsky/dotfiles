-- Global hotkeys for app launching/focusing

-- Cmd+Shift+T: Launch or focus Ghostty
hs.hotkey.bind({"cmd", "shift"}, "t", function()
  local app = hs.application.find("Ghostty")
  if app then
    app:activate()
  else
    hs.application.launchOrFocus("Ghostty")
  end
end)
