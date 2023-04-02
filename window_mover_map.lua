--
-- Maps for window_mover
--

local logger = hs.logger.new('window_mover_map', 'debug')
local stack = require('lib/stack'):new(5)

Wmm = {}

-- Sturecture:
--    { numberOfScreen: {winId: frame} }
Wmm.windowPositionAndSizeMap = {}

--
-- Get the position and size of the running windows
-- for the current number of screens
--
function Wmm.getCurrentWindowPositionAndSizeMap()
  local currentNumberOfScreen = #hs.screen.allScreens()
  local winPositionAndSizeMap = Wmm.windowPositionAndSizeMap[currentNumberOfScreen]
  if (not winPositionAndSizeMap) then
    logger:d('No windowPositionAndSizeMap for the current number of screens: ' .. currentNumberOfScreen)
    return {}
  end

  -- Exclude the windows with size 0
  local validWinPositionAndSizeMap = {}
  for winId, positionAndSize in pairs(winPositionAndSizeMap) do
    if (positionAndSize.w > 0 and positionAndSize.h > 0) then
      validWinPositionAndSizeMap[winId] = positionAndSize
    end
  end

  return validWinPositionAndSizeMap
end

-- TODO use stack
function Wmm.setWindow(numberOfScreen, winId, frame)
  if (not Wmm.windowPositionAndSizeMap[numberOfScreen]) then
    Wmm.windowPositionAndSizeMap[numberOfScreen] = {}
  end

  Wmm.windowPositionAndSizeMap[numberOfScreen][winId] = frame
end

return Wmm
