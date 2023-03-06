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
hs.hotkey.bind({"ctrl", "cmd"}, "0", wl.fullscreenCurrent)
hs.hotkey.bind({"ctrl", "cmd"}, "9", wl.resizeAndCenterCurrent(0.98))
hs.hotkey.bind({"ctrl", "cmd"}, "8", wl.resizeAndCenterCurrent(0.95))
hs.hotkey.bind({"ctrl", "cmd"}, "7", wl.resizeAndCenterCurrent(0.8))

