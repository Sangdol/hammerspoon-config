--
-- Quick app switcher
--
local activeApp = nil

-- Bind Ctrl + Shift + Cmd + H to store the quick app
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "P", function()
  local focusedWindow = hs.window.focusedWindow()
  if focusedWindow then
    activeApp = focusedWindow:application()
    no.alert('Stored quick app: ' .. activeApp:name())
  end
end)

-- Bind Ctrl + Cmd + H to focus the stored quick app
hs.hotkey.bind({"ctrl", "cmd"}, "P", function()
  if activeApp then
    activeApp:activate()
  else
    no.alert('No quick app stored')
  end
end)
