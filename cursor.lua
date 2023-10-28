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
  -- Make it slightly left to the center to scroll on the windows 
  -- occupying the left half of the screen.
  local center = hs.geometry.point(frame.x + frame.w/2 - 30, frame.y + frame.h/2)
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

local function moveCursorToRightSideOfFocusedWindow()
  local frame = hs.window.focusedWindow():frame()
  -- Avoid vertical center of the window to avoid distraction
  local right = hs.geometry.point(frame.x + frame.w - CURSOR_MARGIN, frame.y + 150)
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

local function rightCursorOfFocusedWindow()
  moveCursorToRightSideOfFocusedWindow()
  mouseHighlight()
end

-- Move cursor to the center of current screen
hs.hotkey.bind({"ctrl","cmd"}, "8", leftCursor)
hs.hotkey.bind({"ctrl","cmd"}, "9", centerCursor)
hs.hotkey.bind({"ctrl","cmd"}, "0", rightCursor)

-- Check if a point is inside a rectangle
local function contains(frame, point)
  return point.x >= frame.x and point.x <= (frame.x + frame.w) and
         point.y >= frame.y and point.y <= (frame.y + frame.h)
end

-- Move cursor and focus the window under the cursor
local function focusWindowAtPosition(position)
  hs.mouse.absolutePosition(position)

  local orderedWindows = hs.window.orderedWindows()

  for _, win in ipairs(orderedWindows) do
    local frame = win:frame()

    if contains(frame, position) then
      win:focus()
      break
    end
  end
end

-- Move cursor to the nth main screen
local function focusMainScreen(number)
  return function()
    local targetScreen = sc.getMainScreenByNumber(number)
    local frame = targetScreen:frame()
    local right = hs.geometry.point(frame.x + frame.w - CURSOR_MARGIN, frame.y + frame.h/2)
    focusWindowAtPosition(right)
    mouseHighlight()
  end
end

local function focusSmallestScreen()
  local targetScreen = sc.getSmallestScreen()
  local frame = targetScreen:frame()
  local right = hs.geometry.point(frame.x + frame.w - CURSOR_MARGIN, frame.y + frame.h/2)
  focusWindowAtPosition(right)
  mouseHighlight()
end

hs.hotkey.bind({"ctrl","cmd"}, "j", focusMainScreen(1))
hs.hotkey.bind({"ctrl","cmd"}, "k", focusMainScreen(2))
hs.hotkey.bind({"ctrl","cmd"}, "u", focusSmallestScreen)

-- Move cursor to the focused window screen when an application window is activated
-- if the cursor is not on the focused window screen.
hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function()
  local currentScreen = hs.mouse.getCurrentScreen()
  local focusedScreen = hs.window.focusedWindow():screen()
  if currentScreen ~= focusedScreen then
    rightCursorOfFocusedWindow()
  end
end)
