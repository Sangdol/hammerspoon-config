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
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local center = hs.geometry.point(f.x + f.w/2, f.y + f.h/2)
  hs.mouse.setAbsolutePosition(center)
end

local function main()
  moveCursorToCenter()
  mouseHighlight()
end

hs.hotkey.bind({"ctrl","alt"}, "P", main)
hs.hotkey.bind({"ctrl","shift"}, "P", main)

