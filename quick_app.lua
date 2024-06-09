--
-- Quick app switcher
--

--
-- For quick app switcher
--
local logger = hs.logger.new('quick_app.lua', 'info')
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

local fileAppIndex = {
  path = '/tmp/hammerspoon_quick_app_index',
  read = function(self)
    local file = io.open(self.path, 'r')
    if file then
      local index = file:read()
      file:close()
      return tonumber(index)
    else
      return 1
    end
  end,
  write = function(self, index)
    local file = io.open(self.path, 'w')
    if not file then
      logger:e('Failed to open the file to write the app index')
      return
    end
    file:write(index)
    file:close()
  end
}

local currentAppIndex = fileAppIndex:read()

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
    fileAppIndex:write(currentAppIndex)
end)

-- Hotkey to open the current app
hs.hotkey.bind({"ctrl", "cmd"}, "H", function()
    openCurrentApp()
end)
