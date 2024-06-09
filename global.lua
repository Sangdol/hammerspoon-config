---@diagnostic disable: lowercase-global
--
-- Libraries are global and free. Enjoy.
--

dnd = require('lib/dnd_lib')
no = require('lib/notification_lib')
sc = require('lib/screen_lib')
st = require('lib/string_lib')
timer = require('lib/timer_lib')
tl = require("lib/table_lib")
wl = require("lib/window_lib")

-- Not being used
--bt = require('lib/bluetooth_lib')

function Win()
  return hs.window.focusedWindow()
end

--
-- Dynamic global variables
--
local logger = hs.logger.new('global', 'debug')

Global = {}

function GlobalWatcherCallback()
  logger.d('GlobalWatcherCallback')
  Global.screenCount = #hs.screen.allScreens()
end

GlobalWatcher = hs.screen.watcher.new(GlobalWatcherCallback)
GlobalWatcher:start()
GlobalWatcherCallback()
