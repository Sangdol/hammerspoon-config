--
-- Hammerspoon window and screen wrapper
--

local tl = require('lib/table_lib')
local di = require('lib/device_lib')

local wl = {}

hs.window.animationDuration = 0

function wl.moveWindowToCenter1(win)
  wl.moveWindowToRight(win)

  if #hs.screen.allScreens() == 3 then
    wl.moveWindowToDisplay(win, 2)
  else
    wl.moveWindowToDisplay(win, 1)
  end
end

function wl.moveWindowToCenter2(win)
  wl.moveWindowToLeft(win)
  if #hs.screen.allScreens() == 3 then
    wl.moveWindowToDisplay(win, 3)
  else
    wl.moveWindowToDisplay(win, 2)
  end
end

function wl.currentWindowCenterToggle()
  local win = hs.window.focusedWindow()
  local screen_i = wl.getScreenNumber(win:screen())
  local screen_count = #hs.screen.allScreens()

  if screen_i == screen_count - 1 then
    wl.moveWindowToCenter2(win)
  elseif screen_i == screen_count then
    wl.moveWindowToCenter1(win)
  else
    wl.moveWindowToCenter2(win)
  end
end

function wl.moveFocusedWindowToLeft()
  local win = hs.window.focusedWindow()
  return wl.moveWindowToLeft(win)
end

function wl.moveFocusedWindowToRight()
  local win = hs.window.focusedWindow()
  return wl.moveWindowToRight(win)
end

function wl.moveWindowToLeft(win)
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x
  f.y = screenFrame.y
  f.w = screenFrame.w / 2
  f.h = screenFrame.h
  win:setFrame(f)

  return win
end

function wl.moveWindowToRight(win)
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x + (screenFrame.w / 2)
  f.y = screenFrame.y
  f.w = screenFrame.w / 2
  f.h = screenFrame.h
  win:setFrame(f)

  return win
end

function wl.fullscreenCurrent()
  local win = hs.window.focusedWindow()
  return wl.fullscreen(win)
end

function wl.fullscreen(win)
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x
  f.y = screenFrame.y
  f.w = screenFrame.w
  f.h = screenFrame.h
  win:setFrame(f)

  return win
end

--
-- screen
--

-- return: list of windows of an app e.g., {win1, win2}
function wl.moveAllWindowsToDisplayWithAppName(appName, d)
  -- https://stackoverflow.com/a/58398311/524588
  local displays = hs.screen.allScreens()
  local wins = hs.application.find(appName):allWindows()

  for _, win in ipairs(wins) do
    win:moveToScreen(displays[d], false, true)
  end

  return wins
end

function wl.moveWindowToDisplay(win, d)
  local displays = hs.screen.allScreens()
  win:moveToScreen(displays[d], false, true)
end

function wl.moveFocusedWindowToNextDisplay(maximize)
  local function inner()
    local screens = hs.screen.allScreens()
    local win = hs.window.focusedWindow()
    local current_screen = hs.window.focusedWindow():screen()
    local screen_i =  wl.getScreenNumber(current_screen)
    local target_screen = screens[screen_i % 2 + 1]
    local target_screen_frame = target_screen:frame()
    local milliseconds = 400

    -- This is needed due to the weird bug described in 
    -- the wl.moveFocusedWindowToDisplay() function.
    local is_target_screen_smaller_than_window = win:size().w > target_screen_frame.w
    if is_target_screen_smaller_than_window then
      win = win:setSize(target_screen_frame.w, target_screen_frame.h)
      hs.timer.usleep(milliseconds * 1000)
    end

    win = win:moveToScreen(target_screen, true, false)

    if maximize and not is_target_screen_smaller_than_window then
      hs.timer.usleep(milliseconds * 1000)
      win:setSize(target_screen_frame.w, target_screen_frame.h)
    end
  end

  return inner
end

function wl.moveFocusedWindowToDisplay(d)
  local displays = hs.screen.allScreens()
  local win = hs.window.focusedWindow()
  local appName = win:application():name()
  local chromes = {'Google Chrome', 'Google Chrome Canary', 'Brave Browser'}

  if tl.isInList(chromes, appName) and di.isHugh() then
    -- There's a weird bug where Chrome windows are not moved to another display
    -- if the target display has a different resolution.
    -- This put a window in a wrong size but better than the bug.
    -- https://github.com/Hammerspoon/hammerspoon/issues/2316
    win = win:moveToScreen(displays[d], true, false)
  else
    win:moveToScreen(displays[d], false, true)
  end
end

-- This is only useful when there are three or more screens.
-- Direction: 1 (clockwise), -1 (anticlockwise)
function wl.moveWindowTo(direction)
  local function move()
    local screen = hs.window.focusedWindow():screen()
    local screen_i =  wl.getScreenNumber(screen)

    local MAIN_SCREEN_I = 1
    local LEFT_SCREEN_I = 2
    local RIGHT_SCREEN_I = 3

    if screen_i == MAIN_SCREEN_I then
      -- To avoid confusing direction of windows moving from the main screen
      -- this has fixed directions instead of moving clockwise.
      if direction == -1 then
        wl.moveFocusedWindowToDisplay(LEFT_SCREEN_I)
      elseif direction == 1 then
        wl.moveFocusedWindowToDisplay(RIGHT_SCREEN_I)
      end
    else
      -- This formula gets complicated due to 1-based index.
      wl.moveFocusedWindowToDisplay((screen_i + direction - 1) % 3 + 1)
    end
  end

  return move
end

function wl.getScreenNumber(screen)
  local displays = hs.screen.allScreens()
  local screen_i

  for i, s in pairs(displays) do
    if (screen == s) then
      screen_i =  i
    end
  end

  return screen_i
end

return wl
