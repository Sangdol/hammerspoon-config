--
-- Libraries are global and free. Enjoy.
--

bt = require('lib/bluetooth_lib')
dnd = require('lib/dnd_lib')
espanso = require('lib/espanso_lib')
no = require('lib/notification_lib')
sc = require('lib/screen_lib')
st = require('lib/string_lib')
timer = require('lib/timer_lib')
tl = require("lib/table_lib")
wl = require("lib/window_lib")

function Win()
  return hs.window.focusedWindow()
end
