--
-- iTerm marker
--
-- Adds different colors for different windows
-- to make each iTerm window noticiable.
--

local ca = require('lib/canvas_lib')
local wl = require('lib/window_lib')
local logger = hs.logger.new('iTerm marker', 'debug')

function iTermDrawing(win, appName)
  logger:d(appName)

  logger:d(appName, 'all info', wl.getScreenNumber(win:screen()), win:tabCount())
  if appName == 'iTerm2' and wl.getScreenNumber(win:screen()) == 2 and win:tabCount() < 5 then
    frame = win:frame()
    logger:d(appName, 'show iTerm sign')
    ca.deleteItermSign()
    ca.showItermSign(frame)
  else
    logger:d(appName, 'delete iTerm sign')
    ca.deleteItermSign()
  end
end

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, iTermDrawing)
