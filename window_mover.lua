--
-- Move windows to where they were
--

local logger = hs.logger.new('window_mover', 'debug')

Wm = {}

local interval = 180

-- Sturecture:
--    { numberOfScreen: {winId: screen} }
Wm.windowPositionAndSizeMap = {}

local function getCurrentWindowPositionAndSizeMap()
  local currentNumberOfScreen = #hs.screen.allScreens()
  local winPositionAndSizeMap = Wm.windowPositionAndSizeMap[currentNumberOfScreen]
  if (not winPositionAndSizeMap) then
    logger:d('No windowPositionAndSizeMap for the current number of screens: ' .. currentNumberOfScreen)
    return {}
  end
  return winPositionAndSizeMap
end

function Wm.updateWindowMap()
  logger:d('Updating window map')

  local screenCount = #hs.screen.allScreens()

  if (screenCount == 1) then
    logger:d('No need to update window map for 1 screen')
    return
  end

  --for _, appName in ipairs(appNames) do
  local windows = hs.window.allWindows()
  for _, win in ipairs(windows) do
    -- Do this instead of iterating over appNames
    -- to be able to capture multiple processes with the same app name.
    local screen = win:screen()
    local currentNumberOfScreen = #hs.screen.allScreens()

    logger:d('Update window map for the window: ' .. win:title())

    if (not Wm.windowPositionAndSizeMap[currentNumberOfScreen]) then
      Wm.windowPositionAndSizeMap[currentNumberOfScreen] = {}
    end

    Wm.windowPositionAndSizeMap[currentNumberOfScreen][win:id()] = {
      x = win:frame().x,
      y = win:frame().y,
      w = win:frame().w,
      h = win:frame().h,
    }
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
  -- Debounce the timer
  if (screenWatcherTimer) then
    screenWatcherTimer:stop()
  end

  -- For some reason, it doesn't recognize the number of screens correctly
  -- if it runs immediately after the screen change.
  screenWatcherTimer = hs.timer.doAfter(3, function()
    local screenCount = #hs.screen.allScreens()

    if screenCount == 1 then
      logger:d('Skipping the screen change because the number of screens is 1')
      return
    end

    logger:d('Screen changed. Number of screens: ' .. screenCount)
    Wm.restorePositionAndSize()
  end)
end)

Wm.updateWindowTimer = hs.timer.doEvery(interval, Wm.updateWindowMap)
Wm.updateWindowMap()

