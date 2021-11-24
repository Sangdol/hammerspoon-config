--
-- Window managing shortcuts
--
wl = require('window_lib')

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "l", wl.currentWindowCenterToggle)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveWindowTo(1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveWindowTo(-1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "left", wl.moveFocusedWindowToLeft)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "right", wl.moveFocusedWindowToRight)
hs.hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)

-- Reference
-- - This doesn't make app changing faster.
-- - This doesn't focus back to the previously used window.
-- => basically it's the same as BTT
--hs.hotkey.bind({"ctrl", "cmd"}, "0", function()
  --hs.application.launchOrFocus('iTerm')
--end)
