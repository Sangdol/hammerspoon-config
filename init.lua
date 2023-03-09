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
---@diagnostic disable-next-line: lowercase-global
  app = hs.window.focusedWindow():application()
---@diagnostic disable-next-line: lowercase-global
  win = hs.window.focusedWindow()
  print('Current app name: ' .. app:name())
  print('The current app is accessible via the variable `app`.')
  print('The current window is accessible via the variable `win`.')
end)

require('global')
require('window_mover')
require('caffeinate')
require('window_shortcuts')
require('dnd')
require('menubar')
require('cursor')
