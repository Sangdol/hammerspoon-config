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

-- Sturecture:
--    { currentNumberOfScreen: {winId: screen} }
Wm.windowScreenMap = {}
Wm.windowPositionAndSizeMap = {}

local function getCurrentWindowScreenMap()
  local currentNumberOfScreen = #hs.screen.allScreens()
  local winScreenMap = Wm.windowScreenMap[currentNumberOfScreen]
  if (not winScreenMap) then
    logger:d('No windowScreenMap for the current number of screens: ' .. currentNumberOfScreen)
    return {}
  end
  return winScreenMap
end

local function getCurrentWindowPositionAndSizeMap()
  local currentNumberOfScreen = #hs.screen.allScreens()
  local winPositionAndSizeMap = Wm.windowPositionAndSizeMap[currentNumberOfScreen]
  if (not winPositionAndSizeMap) then
    logger:d('No windowPositionAndSizeMap for the current number of screens: ' .. currentNumberOfScreen)
    return {}
  end
  return winPositionAndSizeMap
end

function Wm.updateWindowScreenMap()
  logger:d('Updating windowScreenMap')

  local screenCount = #hs.screen.allScreens()

  if (screenCount == 1) then
    logger:d('No need to update windowScreenMap for 1 screen')
    return
  end

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
          Wm.windowPositionAndSizeMap[currentNumberOfScreen] = {}
        end
        Wm.windowScreenMap[currentNumberOfScreen][win:id()] = screen
        Wm.windowPositionAndSizeMap[currentNumberOfScreen][win:id()] = {
          x = win:frame().x,
          y = win:frame().y,
          w = win:frame().w,
          h = win:frame().h,
        }
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
      sc.moveWindowToScreen(win, screen, true)
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
        sc.moveWindowToScreen(win, screen, true)
      end
    end
  end
end

function Wm.restorePositionAndSize()
  logger:d('Restoring position and size')

  local winPositionAndSizeMap = getCurrentWindowPositionAndSizeMap()
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    local win = hs.window.get(winId)
    if (win) then
      win:setFrame(positionAndSize)
    end
  end
end

function Wm.restorePositionAndSizeOfApp(appName)
  logger:d('Restoring position and size of the app: ' .. appName)

  local app = hs.application.get(appName)
  if (not app) then
    logger:d("Couldn't get the app: " .. appName)
  else
    logger:d(app, "App found: " .. appName)
    for _, win in ipairs(app:allWindows()) do
      local winPositionAndSizeMap = getCurrentWindowPositionAndSizeMap()
      local positionAndSize = winPositionAndSizeMap[win:id()]
      if (positionAndSize) then
        win:setFrame(positionAndSize)
      end
    end
  end
end

Wm.appWatcher = hs.application.watcher.new(function(appName, event)
  if (event == hs.application.watcher.launched) then
    local screenCount = #hs.screen.allScreens()
    if screenCount == 1 then
      logger:d('Skipping the moving app windows because the number of screens is 1')
      return
    end

    logger:d('App launched. Moving windows: ' .. appName)
    Wm.moveAppWindowsToTheirScreens(appName)
    Wm.restorePositionAndSizeOfApp(appName)
  end
end)

local screenWatcherTimer
Wm.screenWatcher = hs.screen.watcher.new(function()
  -- For some reason, it doesn't recognize the number of screens correctly
  -- if it runs immediately after the screen change.
  screenWatcherTimer = hs.timer.doAfter(3, function()
    if (screenWatcherTimer) then
      -- Debounce the timer
      screenWatcherTimer:stop()
    end

    local screenCount = #hs.screen.allScreens()

    if screenCount == 1 then
      logger:d('Skipping the screen change because the number of screens is 1')
      return
    end

    logger:d('Screen changed. Number of screens: ' .. screenCount)
    Wm.moveAllWindowsToTheirScreens()
    Wm.restorePositionAndSize()
  end)
end)

hs.timer.doEvery(interval, Wm.updateWindowScreenMap)
hs.screen.watcher.new(Wm.moveAllWindowsToTheirScreens):start()
Wm.updateWindowScreenMap()

