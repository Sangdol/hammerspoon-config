-- https://www.hammerspoon.org/go/#smartreload
hs.loadSpoon('ReloadConfiguration')
spoon.ReloadConfiguration:start()

hs.hotkey.bind({'ctrl', 'shift', 'cmd', 'alt'}, 'h', hs.reload)

require('redshift')
require('finder')
require('window_arranger')
require('window_shortcuts')
require('caffeinate')
require('dnd_manager')
