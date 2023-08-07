--
-- To work around the Mac volume lag with bluetooth headphones.
--
local function setVolume(level)
  hs.audiodevice.defaultOutputDevice():setVolume(level)
  hs.alert.show("Volume set to " .. level .. "%")
end

hs.hotkey.bind({"ctrl", "shift"}, "1", function() setVolume(10) end)
hs.hotkey.bind({"ctrl", "shift"}, "2", function() setVolume(20) end)
hs.hotkey.bind({"ctrl", "shift"}, "3", function() setVolume(30) end)
hs.hotkey.bind({"ctrl", "shift"}, "4", function() setVolume(40) end)
hs.hotkey.bind({"ctrl", "shift"}, "5", function() setVolume(50) end)
hs.hotkey.bind({"ctrl", "shift"}, "6", function() setVolume(60) end)
hs.hotkey.bind({"ctrl", "shift"}, "7", function() setVolume(70) end)
hs.hotkey.bind({"ctrl", "shift"}, "8", function() setVolume(80) end)
hs.hotkey.bind({"ctrl", "shift"}, "9", function() setVolume(90) end)
hs.hotkey.bind({"ctrl", "shift"}, "0", function() setVolume(100) end)
