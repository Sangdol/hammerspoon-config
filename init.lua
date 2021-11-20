-- https://www.hammerspoon.org/go/#smartreload
hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()

-- Sometimes it's needed to force reload
-- for example when Redshift doesn't work for a specific screen
-- (a similar issue https://github.com/Hammerspoon/hammerspoon/issues/1197)
hs.hotkey.bind({'ctrl', 'shift', 'cmd', 'alt'}, 'h', hs.reload)

require('redshift')
require('finder')
require('window_arranger')
require('window_shortcuts')
require('caffeinate')
require('dnd_manager')
