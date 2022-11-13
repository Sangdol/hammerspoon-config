--
-- Window functions for multiple screens
--

local sc = {}

-- Delay between window transisions
local function wait()
  timer.sleep(0.3)
end

function sc.moveWindowToCenter1(win)
  wl.moveWindowToRight(win)
  sc.moveWindowToScreen(win, 1)
end

function sc.moveWindowToCenter2(win)
  wl.moveWindowToLeft(win)
  sc.moveWindowToScreen(win, 2)
end

function sc.currentWindowCenterToggle()
  local win = hs.window.focusedWindow()
  local screenI = sc.getScreenNumber(win:screen())
  local screenCount = #hs.screen.allScreens()

  if screenI == screenCount - 1 then
    sc.moveWindowToCenter2(win)
  elseif screenI == screenCount then
    sc.moveWindowToCenter1(win)
  else
    sc.moveWindowToCenter2(win)
  end
end

-- return: list of windows of an app e.g., {win1, win2}
function sc.moveAllWindowsToScreenWithAppName(appName, d)
  -- https://stackoverflow.com/a/58398311/524588
  local screens = hs.screen.allScreens()
  local wins = hs.application.find(appName):allWindows()

  for _, win in ipairs(wins) do
    win:moveToScreen(screens[d], false, true)
  end

  return wins
end

function sc.moveWindowToScreen(win, index)
  local screens = hs.screen.allScreens()
  win:moveToScreen(screens[index], false, true)
end

function sc.moveToSmallerScreen(win, targetScreen)
  -- resize and move
  local targetScreenFrame = targetScreen:frame()

  win:setSize(targetScreenFrame.w, targetScreenFrame.h)
  wait()
  win:moveToScreen(targetScreen, true, false)
end

function sc.moveToBiggerScreen(win, targetScreen, maximize)
  -- move and resize
  local targetScreenFrame = targetScreen:frame()

  win:moveToScreen(targetScreen, true, false)
  if maximize then
    wait()
    win:setTopLeft(targetScreenFrame)
    wait()
    win:setSize(targetScreenFrame.w, targetScreenFrame.h)
  end
end

-- This has lots of hacks to avoid bug
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
function sc.moveFocusedWindowToNextScreen(maximize)
  local function inner()
    local screens = hs.screen.allScreens()
    local win = hs.window.focusedWindow()
    local current_screen = hs.window.focusedWindow():screen()
    local screenI =  sc.getScreenNumber(current_screen)
    local targetScreen = screens[screenI % 2 + 1]
    local targetScreenFrame = targetScreen:frame()

    local isTargetScreenSmallerThanWindow = win:size().w > targetScreenFrame.w
    if isTargetScreenSmallerThanWindow then
      sc.moveToSmallerScreen(win, targetScreen)
    else
      sc.moveToBiggerScreen(win, targetScreen, maximize)
    end

    wait()

    -- move window to the center of the screen based on the window size
    local x = targetScreenFrame.x + (targetScreenFrame.w - win:size().w) / 2
    local y = targetScreenFrame.y + (targetScreenFrame.h - win:size().h) / 2
    win:setTopLeft(x, y)
  end

  return inner
end

function sc.getScreenNumber(screen)
  local screens = hs.screen.allScreens()
  local screenI

  for i, s in pairs(screens) do
    if (screen == s) then
      screenI =  i
    end
  end

  return screenI
end

return sc
