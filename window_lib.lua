wl = {}

--
-- window
--

hs.window.animationDuration = 0

function wl.moveWindowToCenter1(win)
  wl.moveWindowToRight(win)
  wl.moveWindowToDisplay(win, 2)
end

function wl.moveWindowToCenter2(win)
  wl.moveWindowToLeft(win)
  wl.moveWindowToDisplay(win, 3)
end

function wl.currentWindowCenterToggle()
  local win = hs.window.focusedWindow()
  local screen_i = wl.getScreenNumber(win:screen())

  if screen_i == 2 then
    wl.moveWindowToCenter2(win)
  elseif screen_i == 3 then
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

function wl.moveFocusedWindowToDisplay(d)
  local displays = hs.screen.allScreens()
  local win = hs.window.focusedWindow()
  win:moveToScreen(displays[d], false, true)
end

-- direction: 1 (right), -1 (left)
function wl.moveWindowTo(direction)
  function move()
    local screen = hs.window.focusedWindow():screen()
    local screen_i =  wl.getScreenNumber(screen)

    if screen_i == 1 then
      -- to avoid confusing direction of moving from the main screen
      if direction == -1 then
        wl.moveFocusedWindowToDisplay(2)
      elseif direction == 1 then
        wl.moveFocusedWindowToDisplay(3)
      end
    else
      -- formula gets complicated due to 1-based index
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
