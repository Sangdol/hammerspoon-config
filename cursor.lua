--
-- Show me the cursor
--

local DIAMETER = 40
local STROKE_WIDTH = 0.5
local DURATION = 0.5
local COLOR = '#333333'
local ALPHA = 0.3
local CURSOR_MARGIN = 150

local function mouseHighlight()
  local mousepoint = hs.mouse.absolutePosition()
  local rect = hs.geometry.rect(mousepoint.x - DIAMETER/2, mousepoint.y - DIAMETER/2, DIAMETER, DIAMETER)

  local mouseCircle = hs.drawing.circle(rect)
  mouseCircle:setStrokeColor({["hex"]=COLOR,["alpha"]=ALPHA})
  mouseCircle:setFillColor({["hex"]=COLOR,["alpha"]=ALPHA})
  mouseCircle:setFill(true)
  mouseCircle:setStrokeWidth(STROKE_WIDTH)
  mouseCircle:show()

  MouseHighligtTimer = hs.timer.doAfter(DURATION, function() mouseCircle:delete() end)
end

local function moveCursorToCenter()
  local currentScreen = hs.window.focusedWindow():screen()
  local frame = currentScreen:frame()
  local center = hs.geometry.point(frame.x + frame.w/2, frame.y + frame.h/2)
  hs.mouse.absolutePosition(center)
end

local function moveCursorToLeftSide()
  local currentScreen = hs.window.focusedWindow():screen()
  local frame = currentScreen:frame()
  local right = hs.geometry.point(frame.x + CURSOR_MARGIN, frame.y + frame.h/2)
  hs.mouse.absolutePosition(right)
end

local function moveCursorToRightSide()
  local currentScreen = hs.window.focusedWindow():screen()
  local frame = currentScreen:frame()
  local right = hs.geometry.point(frame.x + frame.w - CURSOR_MARGIN, frame.y + frame.h/2)
  hs.mouse.absolutePosition(right)
end

local function centerCursor()
  moveCursorToCenter()
  mouseHighlight()
end

local function leftCursor()
  moveCursorToLeftSide()
  mouseHighlight()
end

local function rightCursor()
  moveCursorToRightSide()
  mouseHighlight()
end

-- Move cursor to the center of current screen
hs.hotkey.bind({"ctrl","cmd"}, "8", leftCursor)
hs.hotkey.bind({"ctrl","cmd"}, "9", centerCursor)
hs.hotkey.bind({"ctrl","cmd"}, "0", rightCursor)

-- Move cursor to the nth main screen
local function clickMainScreen(number)
  return function()
    local targetScreen = sc.getMainScreenByNumber(number)
    local frame = targetScreen:frame()
    local right = hs.geometry.point(frame.x + frame.w - CURSOR_MARGIN, frame.y + frame.h/2)
    hs.eventtap.leftClick(right)
    mouseHighlight()
  end
end

-- Click main screens
hs.hotkey.bind({"ctrl","cmd"}, "j", clickMainScreen(1))
hs.hotkey.bind({"ctrl","cmd"}, "k", clickMainScreen(2))

-- Move cursor to the focused window screen when an application window is activated
-- if the cursor is not on the focused window screen.
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function()
  local currentScreen = hs.mouse.getCurrentScreen()
  local focusedScreen = hs.window.focusedWindow():screen()
  if currentScreen ~= focusedScreen then
    rightCursor()
  end
end)
