--
-- Fix Different
--

local audio = hs.audiodevice

local logger = hs.logger.new('headset_volume', 'debug')
local volumeTimer = nil
local lastVolume = nil
local maxVolume = 30  -- Maximum allowed volume (adjust as needed)
local headsetName = "AirPods Max"  -- Confirm your device's exact name
local volumeFile = os.getenv("HOME") .. "/.headset_volume"

-- Apply stored volume, capped at maxVolume
local function applyStoredVolume()
  logger:d('Applying stored volume')

  local file = io.open(volumeFile, "r")
  if not file then return end

  local storedVol = tonumber(file:read("*a"))
  file:close()

  if not storedVol then return end

  local targetVol = math.min(storedVol, maxVolume)
  local currentDevice = audio.defaultOutputDevice()

  if not currentDevice then return end
  if not string.find(currentDevice:name(), headsetName) then return end

  -- Only set volume if it's different from lastVolume
  if targetVol == lastVolume then
    logger:d("Volume already set to " .. targetVol .. "%")
    return
  end

  currentDevice:setVolume(targetVol)
  lastVolume = targetVol
  logger:d("Volume set to " .. targetVol .. "%")
  hs.alert("Volume set to " .. targetVol .. "%")
end

-- Start monitoring volume changes for the headset
local function startVolumeTimer()
  logger:d('Starting volume timer')
  if volumeTimer then return end

  volumeTimer = hs.timer.new(5, function()
    local currentDevice = audio.defaultOutputDevice()
    if not currentDevice then return end
    if not string.find(currentDevice:name(), headsetName) then return end

    local currentVol = math.floor(currentDevice:volume())
    if currentVol == lastVolume then return end

    lastVolume = currentVol
    logger:d(os.date("%Y-%m-%d %H:%M:%S") .. " - Volume changed to " .. currentVol .. "%")
    hs.execute(string.format("echo '%d' > %s", currentVol, volumeFile))
  end)
  volumeTimer:start()
end

-- Stop monitoring volume
local function stopVolumeTimer()
  logger:d('Stopping volume timer')

  if volumeTimer then
    volumeTimer:stop()
    volumeTimer = nil
  end
end

-- Handle audio device changes
local function deviceChangedCallback(event, deviceName, _, _)
  logger:d('Device changed:', event, deviceName)

  local currentDevice = audio.defaultOutputDevice()

  if currentDevice and string.find(currentDevice:name(), headsetName) then
    -- Delay to override system volume reset
    hs.timer.doAfter(0.5, applyStoredVolume)
    startVolumeTimer()
  else
    stopVolumeTimer()
  end
end

deviceChangedCallback()

-- Initialize audio device watcher
audio.watcher.setCallback(deviceChangedCallback)
audio.watcher.start()
