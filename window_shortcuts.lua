--
-- Window Shortcuts to arrange windows and focus the last active window
--

local wl = require('lib/window_lib')
local logger = hs.logger.new('window_shortcuts', 'info')

Ws = {}

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "l", wl.currentWindowCenterToggle)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveWindowTo(1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveWindowTo(-1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "left", wl.moveFocusedWindowToLeft)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "right", wl.moveFocusedWindowToRight)
hs.hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)

hs.hotkey.bind({"ctrl", "shift", "option", "cmd"}, "p", function()
  print(hs.window.focusedWindow():application():name())
end)

Ws.lastUsedWins = {}

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(win, appName)
  logger:d(appName)
  Ws.lastUsedWins[appName] = win
  logger:d(appName, 'window updated')
end)

-- The appName the function `launchOrFocus()` requires
-- and the appName used in subscribe can be different
-- for example iTerm for `launchOrFocus()` and iTerm2 for `subscribe()`.
-- Due to this, this function can't work for a not running application.
function Ws.selectLastActiveWindow(appName)
  local function selectApp()
    if (Ws.lastUsedWins[appName]) then
      local win = Ws.lastUsedWins[appName]

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

hs.hotkey.bind({"ctrl", "cmd"}, "K", Ws.selectLastActiveWindow('iTerm2'))
hs.hotkey.bind({"ctrl", "cmd"}, "L", Ws.selectLastActiveWindow('IntelliJ IDEA'))
hs.hotkey.bind({"ctrl", "cmd"}, "J", Ws.selectLastActiveWindow('Google Chrome'))
