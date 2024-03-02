--
-- Quick app switcher
--

--
-- For quick app switcher
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


--
-- For browser toggle
--
local appList = {'Google Chrome', 'Firefox'}
local currentAppIndex = 1

-- Function to cycle through the app list
local function cycleApp()
    currentAppIndex = currentAppIndex % #appList + 1
    hs.alert.show(appList[currentAppIndex] .. " is set")
end

-- Function to open the current app
local function openCurrentApp()
    hs.application.launchOrFocus(appList[currentAppIndex])
end

-- Hotkey to cycle through the apps
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "H", function()
    cycleApp()
end)

-- Hotkey to open the current app
hs.hotkey.bind({"ctrl", "cmd"}, "H", function()
    openCurrentApp()
end)
