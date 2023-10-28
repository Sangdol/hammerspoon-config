--
-- To work around the Mac volume lag with bluetooth headphones.
--

local alertSound = hs.sound.getByName('Tink')

local function alert(message)
    hs.alert.closeAll() -- Close any existing alerts
    hs.alert.show(message)

    alertSound:play()
end

-- Helper function to set volume to a specific level
local function setVolume(level)
    hs.audiodevice.defaultOutputDevice():setVolume(level)

    alert("Volume set to " .. level .. "%")
end

-- Helper function to change volume by a given percentage
local function changeVolume(delta)
    local currentVolume = hs.audiodevice.defaultOutputDevice():volume()
    local newVolume = math.min(100, math.max(0, currentVolume + delta))
    newVolume = math.floor(newVolume + 0.5) -- Round to the nearest whole number
    hs.audiodevice.defaultOutputDevice():setVolume(newVolume)

    alert("Volume changed to " .. newVolume .. "%")
end

-- Hotkey definitions for specific levels
hs.hotkey.bind({"ctrl", "alt"}, "0", function() setVolume(10) end)
hs.hotkey.bind({"ctrl", "alt"}, "9", function() setVolume(20) end)
hs.hotkey.bind({"ctrl", "alt"}, "8", function() setVolume(30) end)

-- Hotkey definitions for volume change
hs.hotkey.bind({"ctrl", "alt"}, "-", function() changeVolume(-3) end)
hs.hotkey.bind({"ctrl", "alt"}, "=", function() changeVolume(3) end)
