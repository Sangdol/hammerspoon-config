--
-- Hammerspoon window and screen wrapper
--

local wl = {}

local function wait()
  local milliseconds = 400
  hs.timer.usleep(milliseconds * 1000)
end

hs.window.animationDuration = 0

function wl.moveWindowToCenter1(win)
  wl.moveWindowToRight(win)

  if #hs.screen.allScreens() == 3 then
    wl.moveWindowToScreen(win, 2)
  else
    wl.moveWindowToScreen(win, 1)
  end
end

function wl.moveWindowToCenter2(win)
  wl.moveWindowToLeft(win)
  if #hs.screen.allScreens() == 3 then
    wl.moveWindowToScreen(win, 3)
  else
    wl.moveWindowToScreen(win, 2)
  end
end

function wl.currentWindowCenterToggle()
  local win = hs.window.focusedWindow()
  local screenI = wl.getScreenNumber(win:screen())
  local screenCount = #hs.screen.allScreens()

  if screenI == screenCount - 1 then
    wl.moveWindowToCenter2(win)
  elseif screenI == screenCount then
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
  local screenFrame = win:screen():frame()

  -- Avoiding bug: https://github.com/Hammerspoon/hammerspoon/issues/3224
  win:setTopLeft(screenFrame.x, screenFrame.y)
  wait()
  win:setFrame(screenFrame)

  return win
end

--
-- screen
--

-- return: list of windows of an app e.g., {win1, win2}
function wl.moveAllWindowsToScreenWithAppName(appName, d)
  -- https://stackoverflow.com/a/58398311/524588
  local screens = hs.screen.allScreens()
  local wins = hs.application.find(appName):allWindows()

  for _, win in ipairs(wins) do
    win:moveToScreen(screens[d], false, true)
  end

  return wins
end

function wl.moveWindowToScreen(win, d)
  local screens = hs.screen.allScreens()
  win:moveToScreen(screens[d], false, true)
end

function wl.moveToSmallerScreen(win, targetScreen)
  -- resize and move
  local targetScreenFrame = targetScreen:frame()

  win:setSize(targetScreenFrame.w, targetScreenFrame.h)
  wait()
  win:moveToScreen(targetScreen, true, false)
end

function wl.moveToBiggerScreen(win, targetScreen, maximize)
  -- move and resize
  local targetScreenFrame = targetScreen:frame()

  win:moveToScreen(targetScreen, true, false)
  if maximize then
    wait()
    win:setSize(targetScreenFrame.w, targetScreenFrame.h)
  end
end

-- This has lots of hacks to avoid bug
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
function wl.moveFocusedWindowToNextScreen(maximize)
  local function inner()
    local screens = hs.screen.allScreens()
    local win = hs.window.focusedWindow()
    local current_screen = hs.window.focusedWindow():screen()
    local screenI =  wl.getScreenNumber(current_screen)
    local targetScreen = screens[screenI % 2 + 1]
    local targetScreenFrame = targetScreen:frame()

    local isTargetScreenSmallerThanWindow = win:size().w > targetScreenFrame.w
    if isTargetScreenSmallerThanWindow then
      wl.moveToSmallerScreen(win, targetScreen)
    else
      wl.moveToBiggerScreen(win, targetScreen, maximize)
    end

    wait()

    -- move window to the center of the screen based on the window size
    local x = targetScreenFrame.x + (targetScreenFrame.w - win:size().w) / 2
    local y = targetScreenFrame.y + (targetScreenFrame.h - win:size().h) / 2
    win:setTopLeft(x, y)
  end

  return inner
end

function wl.getScreenNumber(screen)
  local screens = hs.screen.allScreens()
  local screenI

  for i, s in pairs(screens) do
    if (screen == s) then
      screenI =  i
    end
  end

  return screenI
end

return wl
