--
-- Move windows to where they were
--

local logger = hs.logger.new('window_mover', 'debug')

Wm = {}

local WINDOW_MAP_UPDATE_INTERVAL = 180
local SCREEN_WATCHER_INIT_DELAY = 2
local RESTORE_POSITION_AND_SIZE_DELAY = 0.5
local UPDATE_WAKE_UP_DELAY = 30

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

  -- Clear the map to avoid unnecessary window lookup during restoration process
  -- which takes a significant amount of time.
  Wm.windowPositionAndSizeMap = {}

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

local function restorePositionAndSizeOfWindow(win)
  local winPositionAndSizeMap = getCurrentWindowPositionAndSizeMap()
  local positionAndSize = winPositionAndSizeMap[win:id()]
  if (not positionAndSize) then
    logger:d('No position and size for the window: ' .. win:title())
    return
  end

  local app = win:application()

  -- Retry until the window is set to the correct position and size
  timer.safeDoUntil(function()
    return win:frame() == positionAndSize
  end, function()
    win:setFrame(positionAndSize)
  end, function()
    logger:i('Failed to set frame size correctly: ' .. app:name())
  end)
end

function Wm.restorePositionAndSizeOfAllWindows()
  logger:d('Restoring position and size')

  local winPositionAndSizeMap = getCurrentWindowPositionAndSizeMap()
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    local win = hs.window.get(winId)
    if (win) then
      logger:d('Restoring position and size of the window: ' .. win:title())
      logger:d('Position and size: ' .. hs.inspect(positionAndSize))

      restorePositionAndSizeOfWindow(win)
      timer.sleep(RESTORE_POSITION_AND_SIZE_DELAY)
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
      restorePositionAndSizeOfWindow(win)
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
      restorePositionAndSizeOfWindow(win)
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

-- TODO: This doesn't work since the window ID changes when an app is restarted.
--       Work on it later if this annoys me.
--Wm.appWatcher:start()

local screenWatcherTimer
--
-- Screen watcher to move all windows to their screens
--
Wm.screenWatcher = hs.screen.watcher.new(function()
  logger:d('Screen changed')

  if Cafe.isSleeping then
    logger:d('Skipping the screen change because the computer is sleeping')
    return
  end

  -- Debounce the timer
  if (screenWatcherTimer) then
    logger:d('Debouncing the screen watcher timer. ' ..
            'Screen count: '.. #hs.screen.allScreens())
    screenWatcherTimer:stop()
  end

  -- For some reason, it doesn't recognize the number of screens correctly
  -- if it runs immediately after the screen change.
  screenWatcherTimer = hs.timer.doAfter(SCREEN_WATCHER_INIT_DELAY, function()
    local screenCount = #hs.screen.allScreens()

    logger:d('Screen changed. Number of screens: ' .. screenCount)
    Wm.restorePositionAndSizeOfAllWindows()
  end)
end)
Wm.screenWatcher:start()

Wm.updateWindowTimer = hs.timer.doEvery(WINDOW_MAP_UPDATE_INTERVAL, function()
  -- Don't update the window map if the computer is sleeping or if it just woke up.
  local secondsSinceWakeUp = os.time() - Cafe.wakeUpTime
  if Cafe.isSleeping or secondsSinceWakeUp < UPDATE_WAKE_UP_DELAY then
    logger:d('Skipping the window update because the computer is sleeping')
    return
  end

  Wm.updateWindowMap()
end)

Wm.updateWindowMap()
