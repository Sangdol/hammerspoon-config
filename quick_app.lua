--
-- Quick app switcher
--

--
-- For quick app switcher
--
local logger = hs.logger.new('quick_app.lua', 'info')
local home = os.getenv('HOME')
local fileAppName = {
  path = home .. '/.sang_storage/hammerspoon_quick_app_name',
  read = function(self)
    local file = io.open(self.path, 'r')
    if file then
      local name = file:read()
      file:close()
      return name
    else
      return nil
    end
  end,
  write = function(self, name)
    local file = io.open(self.path, 'w')
    if not file then
      logger:e('Failed to open the file to write the app name')
      return
    end
    file:write(name)
    file:close()
  end
}

-- Bind Ctrl + Shift + Cmd + H to store the quick app
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "P", function()
  local focusedWindow = hs.window.focusedWindow()
  if focusedWindow then
    local activeApp = focusedWindow:application()
    if not activeApp then
      no.alert('No active app')
      return
    end

    fileAppName:write(activeApp:name())
    no.alert('Stored quick app: ' .. activeApp:name())
  end
end)

-- Bind Ctrl + Cmd + H to focus the stored quick app
hs.hotkey.bind({"ctrl", "cmd"}, "P", function()
  local activeAppName = fileAppName:read()
  print(activeAppName)
  local activeApp = hs.application.find(activeAppName)
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
    fileAppIndex:write(currentAppIndex)
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
