--
-- Maps for window_mover
--

local logger = hs.logger.new('window_mover_map', 'debug')

-- Sturecture:
--    { numberOfScreen: {winId: frame} }
local windowMap = {}

function windowMap:new()
  local o = {}
  o.maps = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

--
-- Get the position and size of the running windows
-- for the current number of screens
--
function windowMap:getWindowMap(screenCount)
  local winPositionAndSizeMap = self.maps[screenCount]
  if (not winPositionAndSizeMap) then
    logger:d('No window map for the current number of screens: ' .. screenCount)
    return {}
  end

  -- Exclude the windows with size 0
  local filteredMap = {}
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    if (positionAndSize.w > 0 and positionAndSize.h > 0) then
      filteredMap[winId] = positionAndSize
    end
  end

  return filteredMap
end

function windowMap:setWindow(numberOfScreen, winId, frame)
  if (not self.maps[numberOfScreen]) then
    self.maps[numberOfScreen] = {}
  end

  self.maps[numberOfScreen][winId] = frame
end

return windowMap
