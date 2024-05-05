--
-- Keymou replacement
--

--
-- Clicks
-- 
function performClick(button, clicks)
  local currentPos = hs.mouse.getAbsolutePosition()
  local clickEvent = hs.eventtap.event.newMouseEvent(hs.eventtap.event.types["leftMouseDown"], currentPos, {button})
  clickEvent:post()
  hs.timer.usleep(100000)  -- Delay for the click (100 ms)
  clickEvent:setType(hs.eventtap.event.types["leftMouseUp"])
  clickEvent:post()
  if clicks > 1 then
    hs.timer.usleep(100000)  -- Delay between clicks
    performClick(button, clicks - 1)
  end
end

local clickMods = {"ctrl", "alt"}

hs.hotkey.bind(clickMods, "1", function()
  performClick(nil, 1)  -- 'nil' for left button, 'right' for right button
end)

hs.hotkey.bind(clickMods, "2", function()
  performClick("right", 1)
end)

hs.hotkey.bind(clickMods, "3", function()
  performClick(nil, 2)
end)


--
-- Scrolling
--
local scrollDistance = 50
local scrollMods = {"ctrl", "alt"}

-- Helper function to perform scroll
-- direction should be a table with x and y values
local function scroll(dx, dy)
    -- direction should be a table with x and y values
    hs.eventtap.event.newScrollEvent({dx, dy}, {}, "pixel"):post()
end

local scrollUp = function()
    scroll(0, scrollDistance)
end

local scrollDown = function()
    scroll(0, -scrollDistance)
end

local scrollLeft = function()
    scroll(scrollDistance, 0)
end

local scrollRight = function()
    scroll(-scrollDistance, 0)
end

-- https://www.hammerspoon.org/docs/hs.hotkey.html#bind
hs.hotkey.bind({"ctrl", "alt"}, "K", scrollUp, nil, scrollUp)
hs.hotkey.bind({"ctrl", "alt"}, "J", scrollDown, nil, scrollDown)
hs.hotkey.bind({"ctrl", "alt"}, "H", scrollLeft, nil, scrollLeft)
hs.hotkey.bind({"ctrl", "alt"}, "L", scrollRight, nil, scrollRight)
