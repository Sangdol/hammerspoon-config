--
-- Functions and keybindings for debugging.
--
local pasteboard = require("hs.pasteboard")

---@diagnostic disable-next-line: lowercase-global
function copy(text)
  pasteboard.setContents(text)
end

hs.hotkey.bind({"ctrl", "shift", "option", "cmd"}, "p", function()
  ---@diagnostic disable-next-line: lowercase-global
  app = hs.window.focusedWindow():application()

  ---@diagnostic disable-next-line: lowercase-global
  win = hs.window.focusedWindow()

  print('Current app name: ' .. app:name())
  print('The current app is accessible via the variable `app`.')
  print('The current window is accessible via the variable `win`.')
end)

