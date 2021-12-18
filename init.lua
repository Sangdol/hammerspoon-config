--
-- Welcome to Hammerspoon
--

no = require('notification_lib')

hs.hotkey.bind({'ctrl', 'shift', 'cmd', 'alt'}, 'h', function()
  hs.reload()
  no.notify('Config reloaded')
end)

require('redshift')
require('finder')
require('window_arranger')
require('window_shortcuts')
require('watchers')
require('dnd_manager')
