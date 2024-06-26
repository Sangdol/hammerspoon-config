--
-- Window functions for one screen
--

local wl = {}

hs.window.animationDuration = 0

-- Delay between window transisions
local function wait()
  timer.sleep(0.3)
end

function wl.moveFocusedWindowToLeft()
  local win = hs.window.focusedWindow()
  return wl.moveWindowToLeft(win)
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

function wl.moveFocusedWindowToRight()
  local win = hs.window.focusedWindow()
  return wl.moveWindowToRight(win)
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

function wl.moveFocusedWindowToBottom()
  local win = hs.window.focusedWindow()
  return wl.moveWindowToBottom(win)
end

function wl.moveWindowToBottom(win)
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x
  f.y = screenFrame.y + (screenFrame.h / 2)
  f.w = screenFrame.w
  f.h = screenFrame.h / 2
  win:setFrame(f)

  return win
end

function wl.moveFocusedWindowToTop()
  local win = hs.window.focusedWindow()
  return wl.moveWindowToTop(win)
end

function wl.moveWindowToTop(win)
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x
  f.y = screenFrame.y
  f.w = screenFrame.w
  f.h = screenFrame.h / 2
  win:setFrame(f)

  return win
end

-- This is not used at the moment.
function wl.resizeAndCenterCurrent(ratio)
  local resize = function()
    local win = wl.resize(hs.window.focusedWindow(), ratio)
    wait()
    return wl.moveToCenter(win)
  end

  return resize
end

function wl.moveToCenter(win)
  local f = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  f.x = screenFrame.x + (screenFrame.w / 2) - (f.w / 2)
  f.y = screenFrame.y + (screenFrame.h / 2) - (f.h / 2)
  win:setFrame(f)

  return win
end

function wl.resize(win, ratio)
  local f = win:frame()
  local screenFrame = win:screen():frame()

  f.x = screenFrame.x + (screenFrame.w * (1 - ratio) / 2)
  f.y = screenFrame.y + (screenFrame.h * (1 - ratio) / 2)
  f.w = screenFrame.w * ratio
  f.h = screenFrame.h * ratio
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

return wl
