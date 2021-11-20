-- https://www.hammerspoon.org/go/#smartreload
hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

function hello()
  hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end

require('redshift')
require('finder')
require('window_arranger')
require('window_shortcuts')
require('caffeinate')
require('dnd_manager')
