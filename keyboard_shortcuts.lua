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
hotkey.bind({"ctrl", "shift", "cmd"}, "UP", wl.moveFocusedWindowToTop)
hotkey.bind({"ctrl", "shift", "cmd"}, "DOWN", wl.moveFocusedWindowToBottom)
hotkey.bind({"ctrl", "shift"}, "n", sc.moveFocusedWindowToNextScreen(false, -1))
hotkey.bind({"ctrl", "shift"}, "m", sc.moveFocusedWindowToNextScreen(false, 1))
hotkey.bind({"ctrl", "shift", "cmd"}, "n", sc.moveFocusedWindowToNextScreen(true, -1))
hotkey.bind({"ctrl", "shift", "cmd"}, "m", sc.moveFocusedWindowToNextScreen(true, 1))
hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)

local function unminimizeLastWindow()
    local focusedApp = hs.application.frontmostApplication()
    local windows = focusedApp:allWindows()
    -- Filter out only minimized windows
    local minimizedWindows = hs.fnutils.filter(windows, function(window) return window:isMinimized() end)

    if #minimizedWindows > 0 then
        -- Assuming the last one in the list is the most recently minimized
        local lastMinimizedWindow = minimizedWindows[#minimizedWindows]  
        lastMinimizedWindow:unminimize()
    else
        hs.alert.show("No minimized windows found for " .. focusedApp:name())
    end
end

-- Keybinding configuration
hotkey.bind({"ctrl", "alt"}, "M", function()
    unminimizeLastWindow()
end)

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

hotkey.bind({"ctrl", "cmd"}, "[", function() hs.application.launchOrFocus("KakaoTalk") end)
hotkey.bind({"ctrl", "cmd"}, "]", function() hs.application.launchOrFocus("Finder") end)
hotkey.bind({"ctrl", "cmd"}, ";", function() hs.application.launchOrFocus("Microsoft Edge") end)
hotkey.bind({"ctrl", "cmd"}, "\\", function() hs.application.launchOrFocus("Safari") end)
hotkey.bind({"ctrl", "cmd"}, "G", function() activate("MongoDB Compass") end)
hotkey.bind({"ctrl", "cmd"}, "C", function() activate("Google Chrome Canary") end)
hotkey.bind({"ctrl", "cmd"}, "I", function() activate("Anki") end)
hotkey.bind({"ctrl", "cmd"}, "'", function() activate("Slack") end)
hotkey.bind({"ctrl", "alt"}, "P", function() hs.application.launchOrFocus("Preview") end)
hotkey.bind({"ctrl", "alt"}, "R", function() hs.application.launchOrFocus("Reminders") end)
hotkey.bind({"ctrl", "alt"}, "N", function() hs.application.launchOrFocus("Notes") end)
hotkey.bind({"ctrl", "alt"}, "C", function() hs.application.launchOrFocus("Calendar") end)

--
-- Finder
--

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "S", function()
  hs.execute("open ~/screenshots")
end)

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "D", function()
  hs.execute("open ~/Documents")
end)

hs.hotkey.bind({"ctrl", "shift", "alt"}, "D", function()
  hs.execute("open ~/docs")
end)

--
-- Youtube Music
--

hs.hotkey.bind({"shift"}, "F19", function()
  hs.execute("osascript $HOME/projects/osx/applescripts/youtube-music-play-pause.scpt")
end)

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "-", function()
  hs.execute("osascript $HOME/projects/osx/applescripts/youtube-music-like-notification.scpt")
end)

--
-- Notifications
--

hs.hotkey.bind({"ctrl", "cmd"}, ".", function()
  hs.execute("osascript $HOME/projects/osx/applescripts/close-notifications-center.scpt")
end)

hs.hotkey.bind({"ctrl", "cmd"}, ",", function()
  hs.execute("osascript $HOME/projects/osx/applescripts/complete-notifications-center.scpt")
end)

hs.hotkey.bind({"ctrl", "shift", "cmd"}, ".", function()
  hs.execute("osascript $HOME/projects/osx/applescripts/close-one-notification-center.scpt")
end)

hs.hotkey.bind({"ctrl", "shift", "cmd"}, ",", function()
  hs.execute("osascript $HOME/projects/osx/applescripts/complete-one-notification-center.scpt")
end)

--
-- Screenshot
--

-- Function to launch Screenshot.app, wait 0.5 seconds, and press Enter
local function launchScreenshotAndEnter()
  -- Launch Screenshot.app
  hs.application.launchOrFocus("Screenshot")

  -- Delay for 0.5 seconds
  hs.timer.doAfter(0.5, function()
    -- Simulate pressing the Enter key
    hs.eventtap.keyStroke({}, "return")
  end)
end

-- Bind the F19 key to the launchScreenshotAndEnter function
hs.hotkey.bind({"ctrl"}, "F19", launchScreenshotAndEnter)

--
-- noop
--

-- Disable emoji palette
hs.hotkey.bind({"ctrl", "cmd"}, "space", function()
  -- noop
end)

-- Disable opening Mail app when text is highlighted
hs.hotkey.bind({"shift", "cmd"}, "i", function()
  -- noop
end)

--
-- Bridges
--

-- Vimac bridge
hs.hotkey.bind({"cmd"}, "space", function()
  hs.eventtap.keyStroke({"ctrl", "shift", "alt", "cmd"}, "space")
end)

-- iTerm2 + vim theme toggle craziness
local function toggleTheme(color)
  return function()
    local key = "W"

    if color == "light" then
      key = "E"
    end

    hs.execute("$HOME/projects/osx/scripts/iterm_vim_theme.sh " .. color)
    hs.eventtap.keyStroke({"ctrl", "alt", "cmd"}, key)
    hs.eventtap.keyStroke({}, "space")
    hs.eventtap.keyStroke({}, "E")
    hs.eventtap.keyStroke({}, "[")
  end
end

hs.hotkey.bind({"ctrl", "shift", "alt"}, "[", toggleTheme("dark"))
hs.hotkey.bind({"ctrl", "shift", "alt"}, "]", toggleTheme("light"))

--
-- Etc.
--

-- Remap to C-_ for undo and commenting in terminal.
-- C-/ works in nvim but it doesn't work in nvim terminal as an undo.
hs.hotkey.bind({"ctrl"}, "/", function()
  hs.eventtap.keyStroke({"ctrl", "shift"}, "-")
end)

-- Sleep
hs.hotkey.bind({}, "F6", function()
  hs.execute("pmset sleepnow")
end)
