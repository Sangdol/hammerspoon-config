--
-- Show me the cursor!
--

local DIAMETER = 60
local STROKE_WIDTH = 2
local DURATION = 1
local COLOR = '#603b5a'
local ALPHA = 0.4

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
  hs.mouse.setAbsolutePosition(center)
end

local function main()
  moveCursorToCenter()
  mouseHighlight()
end

-- Move cursor to the center of current screen
hs.hotkey.bind({"ctrl","alt"}, "c", main)
hs.hotkey.bind({"ctrl","shift"}, "c", main)

-- Move cursor to the center of next screen
hs.hotkey.bind({"ctrl","alt"}, "n", function()
  local screens = hs.screen.allScreens()
  local currentScreen = hs.mouse.getCurrentScreen()
  local screenI =  sc.getScreenNumber(currentScreen)
  local targetScreen = screens[screenI % 2 + 1]
  local frame = targetScreen:frame()
  local center = hs.geometry.point(frame.x + frame.w/2, frame.y + frame.h/2)
  hs.mouse.setAbsolutePosition(center)
  mouseHighlight()
end)
