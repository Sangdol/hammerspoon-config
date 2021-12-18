--
-- Welcome to Hammerspoon
--

no = require('notification_lib')

hs.hotkey.bind({'ctrl', 'shift', 'cmd', 'alt'}, 'h', function()
  hs.reload()

  -- It seems hs.alert doesn't work before or after hs.reload()
  -- and the notification often doesn't disappear automatically
  -- so keep it commented for now.
  --no.nofity('Config reloaded')
end)

require('redshift')
require('finder')
require('window_arranger')
require('window_shortcuts')
require('watchers')
require('dnd_manager')
