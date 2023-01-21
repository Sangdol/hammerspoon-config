--
-- Show me the cursor!
--

local DIAMETER = 60
local STROKE_WIDTH = 2
local DURATION = 2
local COLOR = '#603b5a'
local ALPHA = 0.8

local function mouseHighlight()
  local mousepoint = hs.mouse.absolutePosition()
  local rect = hs.geometry.rect(mousepoint.x - DIAMETER/2, mousepoint.y - DIAMETER/2, DIAMETER, DIAMETER)

  local mouseCircle = hs.drawing.circle(rect)
  mouseCircle:setStrokeColor({["hex"]=COLOR,["alpha"]=ALPHA})
  mouseCircle:setFill(false)
  mouseCircle:setStrokeWidth(STROKE_WIDTH)
  mouseCircle:show()

  hs.timer.doAfter(DURATION, function() mouseCircle:delete() end)
end

hs.hotkey.bind({"ctrl","alt"}, "P", mouseHighlight)
hs.hotkey.bind({"ctrl","shift"}, "P", mouseHighlight)

