--
-- Move windows to where they were
--

local logger = hs.logger.new('window_mover', 'debug')

Wm = {}

local interval = 30
local appNames = {'Google Chrome', 'Microsoft Edge', 'Slack', 'Safari',
  'iTerm2', 'Reminders', 'Anki', 'Terminal', 'Notes', 'KakaoTalk',
  'Google Chrome Canary', 'Hammerspoon', 'Preview', 'WhatsApp', 'Telegram',
  'Calendar', 'Notion', 'Miro'}

-- { currentNumberOfScreen: {winId: screen} }
Wm.windowScreenMap = {}

local function getCurrentWindowScreenMap()
  local currentNumberOfScreen = #hs.screen.allScreens()
  local winScreenMap = Wm.windowScreenMap[currentNumberOfScreen]
  if (not winScreenMap) then
    logger:d('No windowScreenMap for the current number of screens: ' .. currentNumberOfScreen)
    return {}
  end
  return winScreenMap
end

local function updateWindowScreenMap()
  logger:d('Updating windowScreenMap')

  for _, appName in ipairs(appNames) do
    local app = hs.application.get(appName)
    if (not app) then
      logger:d("Couldn't get the app: " .. appName)
    else
      logger:d(app, "App found: " .. appName)
      for _, win in ipairs(app:allWindows()) do
        local screen = win:screen()
        local currentNumberOfScreen = #hs.screen.allScreens()
        if (not Wm.windowScreenMap[currentNumberOfScreen]) then
          Wm.windowScreenMap[currentNumberOfScreen] = {}
        end
        Wm.windowScreenMap[currentNumberOfScreen][win:id()] = screen
      end
    end
  end
end

function Wm.moveAllWindowsToTheirScreens()
  logger:d('Moving all windows to their screens')

  local winScreenMap = getCurrentWindowScreenMap()
  for winId, screen in pairs(winScreenMap) do
    local win = hs.window.get(winId)
    if (win) then
      sc.moveWindowToScreen(win, screen)
    end
  end
end

function Wm.moveAppWindowsToTheirScreens(appName)
  logger:d('Moving windows of the app to their screens: ' .. appName)

  local app = hs.application.get(appName)
  if (not app) then
    logger:d("Couldn't get the app: " .. appName)
  else
    logger:d(app, "App found: " .. appName)
    for _, win in ipairs(app:allWindows()) do
      local winScreenMap = getCurrentWindowScreenMap()
      local screen = winScreenMap[win:id()]
      if (screen) then
        sc.moveWindowToScreen(win, screen)
      end
    end
  end
end

Wm.appWatcher = hs.application.watcher.new(function(appName, event)
  if (event == hs.application.watcher.launched) then
    logger:d('App launched. Moving windows: ' .. appName)
    Wm.moveAppWindowsToTheirScreens(appName)
  end
end)

Wm.screenWatcher = hs.screen.watcher.new(function()
  logger:d('Screen changed. Number of screens: ' .. #hs.screen.allScreens())
  Wm.moveAllWindowsToTheirScreens()
end)

hs.timer.doEvery(interval, updateWindowScreenMap)
hs.screen.watcher.new(Wm.moveAllWindowsToTheirScreens):start()
updateWindowScreenMap()

