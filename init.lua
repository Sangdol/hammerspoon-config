--
-- Welcome to Hammerspoon
--

hs.loadSpoon("EmmyLua")

hs.hotkey.bind({'ctrl', 'shift', 'cmd', 'alt'}, 'h', function()
  hs.reload()

  -- It seems hs.alert doesn't work before or after hs.reload()
  -- and the notification often doesn't disappear automatically.
  no.notify('Config reloaded')
end)

require('global')
require('debug')
require('caffeinate')
require('window_mover')
require('window_arranger')
require('window_shortcuts')
require('dnd')
require('menubar')
require('cursor')
