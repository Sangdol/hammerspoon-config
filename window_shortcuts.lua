--
-- Window Shortcuts to arrange windows
--
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "l", sc.currentWindowCenterToggle)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveFocusedWindowToLeft)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveFocusedWindowToRight)
hs.hotkey.bind({"ctrl", "shift"}, "n", sc.moveFocusedWindowToNextScreen(false, -1))
hs.hotkey.bind({"ctrl", "shift"}, "m", sc.moveFocusedWindowToNextScreen(false, 1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "n", sc.moveFocusedWindowToNextScreen(true, -1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "m", sc.moveFocusedWindowToNextScreen(true, 1))
hs.hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)
