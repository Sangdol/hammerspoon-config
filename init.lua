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
  CurrentApp = hs.window.focusedWindow():application()
  CurrentWindow = hs.window.focusedWindow()
  print('Current app name: ' .. CurrentApp:name())
  print('The current app is accessible via the variable `CurrentApp`.')
  print('The current window is accessible via the variable `CurrentWindow`.')
end)

require('global')
require('window_arranger')
require('caffeinate')
require('window_focus')
require('window_shortcuts')
require('dnd')
require('menubar')
require('cursor')
