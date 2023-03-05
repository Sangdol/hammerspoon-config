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
--
-- maximize: boolean
-- direction: 1 or -1 (1: right, -1: left)
function sc.moveFocusedWindowToNextScreen(maximize, direction)
  local function inner()
    local win = hs.window.focusedWindow()
    local currentScreen = hs.window.focusedWindow():screen()
    local targetScreen = sc.getNextScreen(currentScreen, direction)
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

-- Find the current screen number in screens
local function getScreenNumber(screens, currentScreen)
  local screenI

  for i, s in ipairs(screens) do
    if (currentScreen == s) then
      screenI =  i
    end
  end

  return screenI
end

local function getOrderedScreens()
  local orderedScreens = {}

  for _, s in pairs(hs.screen.allScreens()) do
    table.insert(orderedScreens, s)
  end

  table.sort(orderedScreens, function(a, b)
    return a:position() < b:position()
  end)

  return orderedScreens
end

-- Return screen number based on the number of screens
local function getScreens()
  local screenCount = #hs.screen.allScreens()
  if screenCount > 2 then
    return getOrderedScreens()
  else
    return hs.screen.allScreens()
  end
end

function sc.getNextScreen(currentScreen, direction)
  local screens = getScreens()
  local screenI = getScreenNumber(screens, currentScreen)
  local screenCount = #screens

  local targetScreenI = (screenI - 1 + direction) % screenCount + 1
  local targetScreen = screens[targetScreenI]

  return targetScreen
end

return sc
