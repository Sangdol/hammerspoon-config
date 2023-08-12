--
-- Sound of Music
--

local sd = {}

-- Get the list of system sound names
local soundNames = hs.sound.systemSounds()

function sd.printSoundNames()
    for i, soundName in ipairs(soundNames) do
        print(i, soundName)
    end
end

-- Create a function to play each sound
function sd.printAndPlaySounds(index)
    if index > #soundNames then
        return
    end
    
    local soundName = soundNames[index]
    print(soundName) -- Print the sound name

    -- Play the sound
    hs.sound.getByName(soundName):play()

    -- Set a timer to play the next sound after 2 seconds
    hs.timer.doAfter(2, function() printAndPlaySounds(index + 1) end)
end

function sd.playSound(soundName)
    hs.sound.getByName(soundName):play()
end

return sd
