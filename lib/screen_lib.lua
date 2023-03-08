--
-- Window functions for multiple screens
--

-- Delay between window transisions
local function wait()
  timer.sleep(0.3)
end

-- Helper functions to get screens based on the number of screens
local S = {
  getOrderedScreens = function()
    local orderedScreens = {}

    for _, s in pairs(hs.screen.allScreens()) do
      table.insert(orderedScreens, s)
    end

    table.sort(orderedScreens, function(a, b)
      return a:position() < b:position()
    end)

    return orderedScreens
  end,
  -- Return screen number based on the number of screens
  getScreens = function(self)
    local screenCount = #hs.screen.allScreens()
    if screenCount > 2 then
      return self:getOrderedScreens()
    else
      return hs.screen.allScreens()
    end
  end,
  -- Find the current screen number in screens
  getScreenNumber = function(self, currentScreen)
    local screens = self:getScreens()
    local screenI

    for i, s in ipairs(screens) do
      if (currentScreen == s) then
        screenI =  i
      end
    end

    return screenI
  end,
  getTwoBiggestScreens = function(self)
    local screens = self:getScreens()
    local screenCount = #screens

    -- To find out the two biggest screens and sort the screens by its position.
    -- Well, this is getting crazy.
    if screenCount > 2 then
      table.sort(screens, function(a, b)
        return a:fullFrame().w * a:fullFrame().h > b:fullFrame().w * b:fullFrame().h
      end)

      screens = {screens[1], screens[2]}
      table.sort(screens, function(a, b)
        return a:position() < b:position()
      end)

      return {screens[1], screens[2]}
    else
      return screens
    end
  end,
  getScreenNumberFromTwoBiggestScreens = function(self, screen)
    local screens = self:getTwoBiggestScreens()
    local screenI

    for i, s in ipairs(screens) do
      if (screen == s) then
        screenI =  i
      end
    end

    return screenI
  end
}

local sc = {}

function sc.getNextScreen(currentScreen, direction)
  local screens = S:getScreens()
  local screenI = S:getScreenNumber(currentScreen)
  local screenCount = #screens

  local targetScreenI = (screenI - 1 + direction) % screenCount + 1
  local targetScreen = screens[targetScreenI]

  return targetScreen
end

function sc.moveWindowToCenter1(win)
  sc.moveWindowToBiggestScreen(win, 1, false)
  wl.moveWindowToRight(win)
end

function sc.moveWindowToCenter2(win)
  sc.moveWindowToBiggestScreen(win, 2, false)
  wl.moveWindowToLeft(win)
end

function sc.currentWindowCenterToggle()
  local win = hs.window.focusedWindow()
  local screenI = S:getScreenNumberFromTwoBiggestScreens(win:screen())

  if screenI == 1 then
    sc.moveWindowToCenter2(win)
  else
    sc.moveWindowToCenter1(win)
  end
end

-- return: list of windows of an app e.g., {win1, win2}
function sc.moveAllWindowsToBiggestScreenWithAppName(appName, screenI, maximize)
  -- https://stackoverflow.com/a/58398311/524588
  local wins = hs.application.find(appName):allWindows()

  for _, win in ipairs(wins) do
    sc.moveWindowToBiggestScreen(win, screenI, maximize)
  end

  return wins
end

function sc.moveWindowToBiggestScreen(win, index, maximize)
  local screens = S:getTwoBiggestScreens()
  sc.moveWindowToScreen(win, screens[index], maximize)
end

function sc.moveToSmallerScreen(win, targetScreen)
  local targetScreenFrame = targetScreen:frame()

  -- resize and move
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

-- This has lots of hacks to avoid bugs
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
--
-- maximize: boolean
-- direction: 1 or -1 (1: right, -1: left)
--
-- This can be replaced with `win:moveToScreen(targetScreen, maximize, true)`
-- once the bugs are fixed.
function sc.moveWindowToScreen(win, targetScreen, maximize)
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

function sc.moveFocusedWindowToScreen(maximize, targetScreen)
  local win = hs.window.focusedWindow()
  sc.moveWindowToScreen(win, targetScreen, maximize)
end

function sc.moveFocusedWindowToNextScreen(maximize, direction)
  local function inner()
    local currentScreen = hs.window.focusedWindow():screen()
    local targetScreen = sc.getNextScreen(currentScreen, direction)
    sc.moveFocusedWindowToScreen(maximize, targetScreen)
  end

  return inner
end

function sc.moveFocusedWindowToScreenWithIndex(maximize, targetScreenI)
  local targetScreen = sc.getScreens()[targetScreenI]
  sc.moveFocusedWindowToScreen(maximize, targetScreen)
end

return sc
