--
-- Window Mover
--
--    Move windows on wake up or screen change
--

local logger = hs.logger.new('window_mover', 'debug')
local windowMap = require('window_mover_map')

Wm = {}

local WINDOW_MAP_UPDATE_INTERVAL = 180
local SCREEN_WATCHER_INIT_DELAY = 2
local RESTORE_POSITION_AND_SIZE_DELAY = 0.5
local UPDATE_WAKE_UP_DELAY = 30

--
-- Save the position and size of the running windows
--
function Wm.updateWindowMap()
  logger:d('Updating window map')

  local currentNumberOfScreen = #hs.screen.allScreens()
  local windows = hs.window.allWindows()
  for _, win in ipairs(windows) do
    logger:d('Update window map for the window: ' .. win:title())
    windowMap.setWindow(currentNumberOfScreen, win:id(), win:frame())
  end
end

-- 
-- Restore the position and size of the running windows
--
local function restoreWindow(win)
  local winPositionAndSizeMap = windowMap.getCurrentWindowPositionAndSizeMap()
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

--
-- Restore the position and size of the running windows
--
function Wm.restoreAll()
  logger:d('Restoring position and size')

  local winPositionAndSizeMap = windowMap.getCurrentWindowPositionAndSizeMap()
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    local win = hs.window.get(winId)
    if (win) then
      logger:d('Restoring position and size of the window: ' .. win:title())
      logger:d('Position and size: ' .. hs.inspect(positionAndSize))

      restoreWindow(win)
      timer.sleep(RESTORE_POSITION_AND_SIZE_DELAY)
    end
  end
end

local screenWatcherTimer
function Wm.screenWatcherHandler()
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
    no.alert('Starting moving windows')
    Wm.restoreAll()
  end)
end

--
-- Screen watcher to move all windows to their screens
--
Wm.screenWatcher = hs.screen.watcher.new(Wm.screenWatcherHandler)
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
