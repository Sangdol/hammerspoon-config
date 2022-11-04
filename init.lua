--
-- Welcome to Hammerspoon
--

-- For debugging in the console
Tl = require("lib/table_lib")

local no = require('lib/notification_lib')

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

require('finder')
require('window_arranger')
require('caffeinate')
require('window_shortcuts')
require('dnd')
require('iterm_marker')


-- Use Flux instead since there are some cons (2021.01.12)
-- - one of screens doesn't take on a color often times and I have to reload config.
-- - it often doesn't change colors smoothly.
-- - I need to set up time manually.
--require('redshift')
