--
-- iTerm marker
--
-- Adds different colors for different windows
-- to make each iTerm window noticiable.
--

local ca = require('lib/canvas_lib')
local wl = require('lib/window_lib')
local logger = hs.logger.new('iTerm marker', 'info')

It = {}

-- This is design to be used with multiple iTerm applications.
function It.iTermDrawing(wrongWin, appName)
  -- This information is wrong when there are multiple duplicated applications.
  logger:d(appName, 'all info', wl.getScreenNumber(wrongWin:screen()), wrongWin:tabCount())

  local focusedWin = hs.window.focusedWindow()
  logger:d(appName, 'all info focusedWindow', wl.getScreenNumber(focusedWin:screen()), focusedWin:tabCount())

  if appName == 'iTerm2' and wl.getScreenNumber(focusedWin:screen()) == 2 and focusedWin:tabCount() < 5 then
    local frame = focusedWin:frame()
    logger:d(appName, 'show iTerm sign')
    ca.deleteItermSign()
    ca.showItermSign(frame)
  else
    logger:d(appName, 'delete iTerm sign')
    ca.deleteItermSign()
  end
end

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, It.iTermDrawing)
