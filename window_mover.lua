--
-- Move windows to where they were
--

local logger = hs.logger.new('window_mover', 'debug')

Wm = {}

local interval = 180

-- Sturecture:
--    { numberOfScreen: {winId: frame} }
Wm.windowPositionAndSizeMap = {}

--
-- Get the position and size of the running windows
-- for the current number of screens
--
local function getCurrentWindowPositionAndSizeMap()
  local currentNumberOfScreen = #hs.screen.allScreens()
  local winPositionAndSizeMap = Wm.windowPositionAndSizeMap[currentNumberOfScreen]
  if (not winPositionAndSizeMap) then
    logger:d('No windowPositionAndSizeMap for the current number of screens: ' .. currentNumberOfScreen)
    return {}
  end

  -- Exclude the windows with size 0
  local validWinPositionAndSizeMap = {}
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    if (positionAndSize.w > 0 and positionAndSize.h > 0) then
      validWinPositionAndSizeMap[winId] = positionAndSize
    end
  end

  return validWinPositionAndSizeMap
end

--
-- Save the position and size of the running windows
--
function Wm.updateWindowMap()
  logger:d('Updating window map')

  local screenCount = #hs.screen.allScreens()

  if (screenCount == 1) then
    logger:d('No need to update window map for 1 screen')
    return
  end

  local windows = hs.window.allWindows()
  for _, win in ipairs(windows) do
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

function Wm.restorePositionAndSizeOfAllWindows()
  logger:d('Restoring position and size')

  local winPositionAndSizeMap = getCurrentWindowPositionAndSizeMap()
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    local win = hs.window.get(winId)
    if (win) then
      logger:d('Restoring position and size of the window: ' .. win:title())
      logger:d('Position and size: ' .. hs.inspect(positionAndSize))
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

--
-- App watcher to move windows to their screens on startup
--
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
Wm.appWatcher:start()

local screenWatcherTimer
--
-- Screen watcher to move all windows to their screens
--
Wm.screenWatcher = hs.screen.watcher.new(function()
  logger:d('Screen changed')

  -- Debounce the timer
  if (screenWatcherTimer) then
    logger:d('Debouncing the screen watcher timer')
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
    Wm.restorePositionAndSizeOfAllWindows()
  end)
end)
Wm.screenWatcher:start()

Wm.updateWindowTimer = hs.timer.doEvery(interval, Wm.updateWindowMap)
Wm.updateWindowMap()
