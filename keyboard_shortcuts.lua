--
-- Hotkeys
--
local hotkey = require "hs.hotkey"

--
-- Window Shortcuts to arrange windows
--
hotkey.bind({"ctrl", "shift", "cmd"}, "l", sc.currentWindowCenterToggle)
hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveFocusedWindowToLeft)
hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveFocusedWindowToRight)
hotkey.bind({"ctrl", "shift"}, "n", sc.moveFocusedWindowToNextScreen(false, -1))
hotkey.bind({"ctrl", "shift"}, "m", sc.moveFocusedWindowToNextScreen(false, 1))
hotkey.bind({"ctrl", "shift", "cmd"}, "n", sc.moveFocusedWindowToNextScreen(true, -1))
hotkey.bind({"ctrl", "shift", "cmd"}, "m", sc.moveFocusedWindowToNextScreen(true, 1))
hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)

--
-- Application shortcuts to launch applications
--

-- Function to toggle visibility of an app
local function activate(name)
    local app = hs.application.find(name)
    if app then
        app:activate()
    end
end

hotkey.bind({"ctrl", "alt"}, "I", function() activate("Anki") end)
hotkey.bind({"ctrl", "cmd"}, "[", function() hs.application.launchOrFocus("KakaoTalk") end)
hotkey.bind({"ctrl", "cmd"}, "G", function() activate("MongoDB Compass") end)
hotkey.bind({"ctrl", "cmd"}, "N", function() hs.application.launchOrFocus("Notes") end)
hotkey.bind({"ctrl", "cmd"}, "R", function() hs.application.launchOrFocus("Reminders") end)
hotkey.bind({"ctrl", "alt"}, "'", function() activate("Slack") end)
hotkey.bind({"ctrl", "alt"}, "C", function() activate("Google Chrome Canary") end)
hotkey.bind({"ctrl", "alt"}, "\\", function() activate("Safari") end)
hotkey.bind({"ctrl", "cmd"}, "]", function() hs.application.launchOrFocus("Finder") end)
hotkey.bind({"ctrl", "cmd"}, "C", function() hs.application.launchOrFocus("Calendar") end)
hotkey.bind({"ctrl", "cmd"}, ";", function() hs.application.launchOrFocus("Microsoft Edge") end)
hotkey.bind({"ctrl", "cmd"}, "P", function() hs.application.launchOrFocus("Preview") end)
