--
-- Show me the cursor
--

local DIAMETER = 40
local STROKE_WIDTH = 0.5
local DURATION = 0.5
local COLOR = '#333333'
local ALPHA = 0.3

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

local function centerCursor()
  moveCursorToCenter()
  mouseHighlight()
end

-- Move cursor to the center of current screen
hs.hotkey.bind({"ctrl","alt"}, "c", centerCursor)
hs.hotkey.bind({"ctrl","shift"}, "c", centerCursor)

-- This function finds the next screen based on the current mouse position.
local function moveCursorToNextScreen(direction)
  return function()
    local currentScreen = hs.mouse.getCurrentScreen()
    local targetScreen = sc.getNextScreen(currentScreen, direction)
    local frame = targetScreen:frame()
    local center = hs.geometry.point(frame.x + frame.w/2, frame.y + frame.h/2)
    hs.mouse.absolutePosition(center)
    mouseHighlight()
  end
end

-- Move cursor to the center of next screen
hs.hotkey.bind({"ctrl","alt"}, "n", moveCursorToNextScreen(-1))
hs.hotkey.bind({"ctrl","alt"}, "m", moveCursorToNextScreen(1))

-- Move cursor to the focused window screen when an application window is activated
-- if the cursor is not on the focused window screen.
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function()
  local currentScreen = hs.mouse.getCurrentScreen()
  local focusedScreen = hs.window.focusedWindow():screen()
  if currentScreen ~= focusedScreen then
    centerCursor()
  end
end)
