--
-- Window Mover
--
--    Move windows on wake up or screen change
--

local logger = hs.logger.new('window_mover', 'debug')

Wm = {}
Wm.stacks = require('window_mover_stacks')

local WINDOW_MAP_UPDATE_INTERVAL = 180
local UPDATE_WAKE_UP_DELAY = 30

-- hs.window.get() returns nil if the delay is too short.
local SCREEN_WATCHER_INIT_DELAY = 4

--
-- Save the position and size of the running windows
--
function Wm.insertWindowMap()
  logger:d('Inserting a new window map')

  local windowMap = {}
  local windows = hs.window.allWindows()
  for _, win in ipairs(windows) do
    logger:d('Update window map for the window: ' .. win:title())

    local frame = win:frame()
    if (frame.w > 0 and frame.h > 0) then
      windowMap[win:id()] = frame
    end
  end

  Wm.stacks.push(windowMap)
end

-- 
-- Restore the position and size of the running windows
--
local function restoreWindow(win)
  local windowMap = Wm.stacks.peek()
  if (not windowMap) then
    logger:d('No window map to restore for the current number of screens')
    return
  end

  local frame = windowMap[win:id()]
  if (not frame) then
    logger:d('No position and size for the window: ' .. win:title())
    return
  end

  local app = win:application()

  -- Retry until the window is set to the correct position and size
  timer.safeDoUntil(function()
    return win:frame() == frame
  end, function()
    win:setFrame(frame)
  end, function()
    logger:i('Failed to set frame size correctly: ' .. app:name())
  end)
end

--
-- Restore the position and size of the running windows
--
function Wm.restoreAll()
  logger:d('Restoring position and size')

  local windowMap = Wm.stacks.peek()
  if (not windowMap) then
    logger:d('No window map to restore for the current number of screens')
    return
  elseif tl.tableLength(windowMap) == 0 then
    logger:d('Window map is empty')
    return
  end

  for winId, frame in pairs(windowMap) do
    local win = hs.window.get(winId)
    if (win) then
      logger:d('Restoring position and size of the window: ' .. win:title())
      logger:d('Position and size: ' .. hs.inspect(frame))

      restoreWindow(win)
    else
      logger:d('Window not found: ' .. winId)
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

function Wm.restorePreviousMap()
  if Wm.stacks.isEmpty() then
    logger:d('No previous window map')
    return
  else
    logger:d('Using previous window map')
    Wm.stacks.pop()
    Wm.restoreAll()
  end
end

hs.hotkey.bind({"ctrl", "shift"}, "r", Wm.restorePreviousMap)

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

  Wm.insertWindowMap()
end)

Wm.insertWindowMap()
