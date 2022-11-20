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

-- For debugging
hs.hotkey.bind({"ctrl", "shift", "option", "cmd"}, "p", function()
  print(hs.window.focusedWindow():application():name())
end)

require('global')
require('window_arranger')
require('caffeinate')
require('window_shortcuts')
require('dnd')

