--
-- To work around the Mac volume lag with bluetooth headphones.
--

-- Helper function to set volume to a specific level
local function setVolume(level)
    hs.audiodevice.defaultOutputDevice():setVolume(level)
    hs.alert.show("Volume set to " .. level .. "%")
end

-- Helper function to change volume by a given percentage
local function changeVolume(delta)
    local currentVolume = hs.audiodevice.defaultOutputDevice():volume()
    local newVolume = math.min(100, math.max(0, currentVolume + delta))
    newVolume = math.floor(newVolume + 0.5) -- Round to the nearest whole number
    hs.audiodevice.defaultOutputDevice():setVolume(newVolume)
    hs.alert.closeAll() -- Close any existing alerts
    hs.alert.show("Volume changed to " .. newVolume .. "%")
end

-- Hotkey definitions for specific levels
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

-- Hotkey definitions for volume change
hs.hotkey.bind({"ctrl", "alt"}, "-", function() changeVolume(-5) end)
hs.hotkey.bind({"ctrl", "alt"}, "=", function() changeVolume(5) end)
