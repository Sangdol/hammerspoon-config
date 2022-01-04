--
-- Window managing shortcuts
--

ws = {}
wl = require('window_lib')
local logger = hs.logger.new('window_shortcuts', 'info')

hs.hotkey.bind({"ctrl", "shift", "cmd"}, "l", wl.currentWindowCenterToggle)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "k", wl.moveWindowTo(1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "j", wl.moveWindowTo(-1))
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "left", wl.moveFocusedWindowToLeft)
hs.hotkey.bind({"ctrl", "shift", "cmd"}, "right", wl.moveFocusedWindowToRight)
hs.hotkey.bind({"ctrl", "cmd"}, "f", wl.fullscreenCurrent)

ws.lastUsedWins = {}

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(win, appName)
  ws.lastUsedWins[appName] = win
  logger:d(appName, 'window updated')
end)

function ws.selectLastActiveWindow(appName)
  function selectApp()
    if (ws.lastUsedWins[appName]) then
      local win = ws.lastUsedWins[appName]
      -- https://github.com/Hammerspoon/hammerspoon/issues/370#issuecomment-615535897
      win:application():activate()
      hs.timer.doAfter(0.001, function()
        win:focus()
      end)
    else
      hs.application.get(appName):mainWindow():focus()

      -- This requires different appName e.g., iTerm2 vs. iTerm.
      -- hs.application.launchOrFocus(appName)
    end
  end

  return selectApp
end

hs.hotkey.bind({"ctrl", "cmd"}, "K", ws.selectLastActiveWindow('iTerm2'))
hs.hotkey.bind({"ctrl", "cmd"}, "L", ws.selectLastActiveWindow('IntelliJ IDEA'))
