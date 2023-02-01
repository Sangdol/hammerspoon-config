--
-- Window Shortcuts to arrange windows and focus the last active window
--
--

local logger = hs.logger.new('window_shortcuts', 'info')

local ws = {}

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "l", sc.currentWindowCenterToggle)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveFocusedWindowToLeft)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveFocusedWindowToRight)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "n", sc.moveFocusedWindowToNextScreen(false))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "m", sc.moveFocusedWindowToNextScreen(true))
hs.hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)
hs.hotkey.bind({"ctrl", "cmd"}, "0", wl.fullscreenCurrent)
hs.hotkey.bind({"ctrl", "cmd"}, "9", wl.resizeAndCenterCurrent(0.98))
hs.hotkey.bind({"ctrl", "cmd"}, "8", wl.resizeAndCenterCurrent(0.95))
hs.hotkey.bind({"ctrl", "cmd"}, "7", wl.resizeAndCenterCurrent(0.8))

--
-- Shortcuts to focus the last used window
--
ws.lastUsedWins = {}

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(win, appName)
  logger:d(appName)
  ws.lastUsedWins[appName] = win
  logger:d(appName, 'window updated')
end)

-- The appName the function `launchOrFocus()` requires
-- and the appName used in subscribe can be different
-- for example iTerm for `launchOrFocus()` and iTerm2 for `subscribe()`.
-- Due to this, this function can't work for a not running application.
function ws.selectLastActiveWindow(appName)
  local function selectApp()
    if (ws.lastUsedWins[appName]) then
      local win = ws.lastUsedWins[appName]

      -- A hack to focus the last used window.
      -- https://github.com/Hammerspoon/hammerspoon/issues/370#issuecomment-615535897
      win:application():activate()
      hs.timer.doAfter(0.01, function()
        win:focus()
      end)
    else
      -- This won't work when the app is not running.
      hs.application.get(appName):mainWindow():focus()

      -- This has to be the exact name instead of 'hint' unlike the `get()` function.
      -- For some reason, iTerm has two names iTerm2 and iTerm,
      -- and this won't work for 'iTerm2' if the application name is iTerm.
      -- hs.application.launchOrFocus(appName)
    end
  end

  return selectApp
end

hs.hotkey.bind({"ctrl", "cmd"}, "J", ws.selectLastActiveWindow('Google Chrome'))
hs.hotkey.bind({"ctrl", "cmd"}, "C", ws.selectLastActiveWindow('Google Chrome Canary'))
hs.hotkey.bind({"ctrl", "cmd"}, "U", ws.selectLastActiveWindow('Firefox'))
hs.hotkey.bind({"ctrl", "cmd"}, ";", ws.selectLastActiveWindow('Brave Browser'))
hs.hotkey.bind({"ctrl", "cmd"}, "I", ws.selectLastActiveWindow('Anki'))
