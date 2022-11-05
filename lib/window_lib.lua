--
-- Window functions for one screen
--

local wl = {}

hs.window.animationDuration = 0

-- Delay between window transisions
local function wait()
  timer.sleep(0.4)
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

  if win:frame() == win:screen():frame() then
    return wl.almostFullscreen(win, 0.98)
  else
    return wl.fullscreen(win)
  end
end

function wl.almostFullscreen(win, ratio)
  local f = win:frame()
  local screenFrame = win:screen():frame()

  f.x = screenFrame.x + (screenFrame.w * (1 - ratio) / 2)
  f.y = screenFrame.y + (screenFrame.h * (1 - ratio) / 2)
  f.w = screenFrame.w * ratio
  f.h = screenFrame.h * ratio
  win:setFrame(f)

  return win
end

function wl.fullscreen(win)
  local screenFrame = win:screen():frame()

  -- Avoiding bug: https://github.com/Hammerspoon/hammerspoon/issues/3224
  win:setTopLeft(screenFrame.x, screenFrame.y)
  wait()
  win:setFrame(screenFrame)

  return win
end

return wl
