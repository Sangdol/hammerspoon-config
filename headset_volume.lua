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

-- Monitoring variables
local isMonitoring = false
local monitorTimer = nil
local checkVolumeTimer = nil

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

  local currentVol = math.floor(currentDevice:volume())
  if targetVol == currentVol then
    logger:d("Volume already set to " .. targetVol .. "%")
    return
  end

  -- Set volume using AppleScript to ensure UI synchronization
  local command = string.format("osascript -e 'set volume output volume %d'", targetVol)
  hs.execute(command)

  lastVolume = targetVol
  logger:d("Volume set to " .. targetVol .. "%")
  hs.alert("Volume set to " .. targetVol .. "%")
end

-- Start monitoring volume changes for the headset
-- and record the volume in a file.
local function startVolumeTimer()
  logger:d('Starting volume timer')
  if volumeTimer then return end

  volumeTimer = hs.timer.new(5, function()
    local currentDevice = audio.defaultOutputDevice()
    if not currentDevice then return end
    if not string.find(currentDevice:name(), headsetName) then return end

    local currentVol = math.floor(currentDevice:volume())
    if currentVol == lastVolume then return end

    -- Do not save if it's 50% during monitoring
    if isMonitoring and currentVol == 50 then
      logger:d("Ignoring system reset to 50% during monitoring")
      return
    end

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

local function cleanupMonitoring()
    isMonitoring = false
    if monitorTimer then
        monitorTimer:stop()
        monitorTimer = nil
    end
    if checkVolumeTimer then
        checkVolumeTimer:stop()
        checkVolumeTimer = nil
    end
end

--
-- Monitor for system-initiated volume resets
-- which occur when the headset is connected
--
local function setupMonitoringPeriod()
  cleanupMonitoring()  -- Clear any existing monitoring

  isMonitoring = true
  logger:d("Starting 20-second monitoring period")

  -- Set monitoring window duration
  monitorTimer = hs.timer.doAfter(20, function()
    logger:d("Monitoring period ended")
    isMonitoring = false
    monitorTimer = nil
  end)

  -- Check for system-initiated volume resets every second
  checkVolumeTimer = hs.timer.new(1, function()
    if not isMonitoring then
      if checkVolumeTimer then
        checkVolumeTimer:stop()
        checkVolumeTimer = nil
      end
      return
    end

    local currentDevice = audio.defaultOutputDevice()
    if currentDevice and currentDevice:name():find(headsetName) then
      local currentVol = math.floor(currentDevice:volume())
      logger:d("Monitoring check, current volume: " .. currentVol)

      if currentVol == 50 then
        logger:d("System reset detected (50%). Reapplying stored volume.")
        applyStoredVolume()
      end
    end
  end)
  checkVolumeTimer:start()
end

--[[
  Device Connection Handlers
--]]
local function handleHeadsetConnected()
  -- Initial volume restore attempt
  hs.timer.doAfter(0.5, applyStoredVolume)

  -- Start regular volume tracking
  startVolumeTimer()

  -- Begin monitoring for system-initiated resets
  setupMonitoringPeriod()
end

local function handleHeadsetDisconnected()
    stopVolumeTimer()
    cleanupMonitoring()
end

--[[
  Main Device Change Handler
--]]
local function deviceChangedCallback(event, deviceName)
    logger:d('Device changed:', event, deviceName)

    local currentDevice = audio.defaultOutputDevice()
    local isTargetDevice = currentDevice and currentDevice:name():find(headsetName)

    if isTargetDevice then
        handleHeadsetConnected()
    else
        handleHeadsetDisconnected()
    end
end

-- Initialization
deviceChangedCallback()
audio.watcher.setCallback(deviceChangedCallback)
audio.watcher.start()
