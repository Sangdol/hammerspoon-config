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


-- 
-- Cursor movement (fast)
--
local cursorMods = {"ctrl", "shift"}
local cursorDistance = 120

local function moveCursor(dx, dy)
    local currentPos = hs.mouse.getAbsolutePosition()
    local newPos = hs.geometry.point(currentPos.x + dx, currentPos.y + dy)
    hs.mouse.setAbsolutePosition(newPos)
end

local moveUp = function()
    moveCursor(0, -cursorDistance)
end

local moveDown = function()
    moveCursor(0, cursorDistance)
end

local moveLeft = function()
    moveCursor(-cursorDistance, 0)
end

local moveRight = function()
    moveCursor(cursorDistance, 0)
end

hs.hotkey.bind(cursorMods, "K", moveUp, nil, moveUp)
hs.hotkey.bind(cursorMods, "J", moveDown, nil, moveDown)
hs.hotkey.bind(cursorMods, "H", moveLeft, nil, moveLeft)
hs.hotkey.bind(cursorMods, "L", moveRight, nil, moveRight)

--
-- Cursor movement (slow)
--
local slowCursorMods = {"ctrl", "shift", "alt"}
local slowCursorDistance = 15

local slowMoveUp = function()
    moveCursor(0, -slowCursorDistance)
end

local slowMoveDown = function()
    moveCursor(0, slowCursorDistance)
end

local slowMoveLeft = function()
    moveCursor(-slowCursorDistance, 0)
end

local slowMoveRight = function()
    moveCursor(slowCursorDistance, 0)
end

hs.hotkey.bind(slowCursorMods, "K", slowMoveUp, nil, slowMoveUp)
hs.hotkey.bind(slowCursorMods, "J", slowMoveDown, nil, slowMoveDown)
hs.hotkey.bind(slowCursorMods, "H", slowMoveLeft, nil, slowMoveLeft)
hs.hotkey.bind(slowCursorMods, "L", slowMoveRight, nil, slowMoveRight)

