--
-- Welcome to Hammerspoon
--

local no = require('lib/notification_lib')

hs.hotkey.bind({'ctrl', 'shift', 'cmd', 'alt'}, 'h', function()
  hs.reload()

  -- It seems hs.alert doesn't work before or after hs.reload()
  -- and the notification often doesn't disappear automatically.
  no.notify('Config reloaded')
end)

require('finder')
require('window_arranger')
require('window_shortcuts')
require('caffeinate')
require('dnd')

-- Use Flux instead since there are some cons (2021.01.12)
-- - one of screens doesn't take on a color often times and I have to reload config.
-- - it often doesn't change colors smoothly.
-- - I need to set up time manually.
--require('redshift')
