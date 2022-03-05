--
-- Window managing shortcuts
--

ws = {}
wl = require('lib/window_lib')
local logger = hs.logger.new('window_shortcuts', 'info')

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "l", wl.currentWindowCenterToggle)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveWindowTo(1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveWindowTo(-1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "left", wl.moveFocusedWindowToLeft)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "right", wl.moveFocusedWindowToRight)
hs.hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)

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
  function selectApp()
    if (ws.lastUsedWins[appName]) then
      local win = ws.lastUsedWins[appName]

      logger:d('b')
      -- https://github.com/Hammerspoon/hammerspoon/issues/370#issuecomment-615535897
      win:application():activate()
      hs.timer.doAfter(0.001, function()
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

hs.hotkey.bind({"ctrl", "cmd"}, "K", ws.selectLastActiveWindow('iTerm2'))
hs.hotkey.bind({"ctrl", "cmd"}, "L", ws.selectLastActiveWindow('IntelliJ IDEA'))
hs.hotkey.bind({"ctrl", "cmd"}, "J", ws.selectLastActiveWindow('Google Chrome'))
