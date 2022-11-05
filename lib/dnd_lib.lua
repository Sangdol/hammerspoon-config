--
-- Do Not Disturb utility
--
-- You need to set up a shortcut to toggle Do Not Disturb to use this script.
-- See the dndKeyStroke() function.
--

local dnd = {}
local logger = hs.logger.new('dnd_lib', 5)

function dnd.isOn()
  -- 1: on, 0: off
  local result = hs.execute('defaults read com.apple.controlcenter "NSStatusItem Visible FocusModes"')
  result = st.trim(result)

  return result == '1'
end

-- The shortcut for Turn Do Not Disturb On/Off has to be set via:
--   System Preferences - Keyboard - Shortcuts - Mission Control - Turn Do Not Disturb On/Off
local function dndKeyStroke()
  hs.eventtap.keyStroke({'ctrl', 'alt', 'cmd', 'shift'}, 'z')
end

function dnd.turnOn()
  no.alert('Turning DND On')

  if dnd.isOn() then
    logger:d('DND is already on.')
  else
    logger:d('Turning DND On')
    dndKeyStroke()
  end
end

function dnd.turnOff()
  no.alert('Turning DND Off')

  if not dnd.isOn() then
    logger:d('DND is already off.')
  else
    logger:d('Turning DND Off')
    dndKeyStroke()
  end
end

-- It has a retry logic since dndKeyStroke() could fail
-- especially when it's triggered right after waking up.
--
-- sleep() is needed between retrial since it takes time
-- until a change is applied and isOn() returns correct state.
function dnd.turnOffAfterSleep()
  timer.safeDoUntil(function()
    return not dnd.isOn()
  end, function()
    dndKeyStroke()
    timer.sleep(8)
  end, function()
    logger:d('Failed to trun DND Off')
  end)
end

function dnd.conditionallyTurnOnOff()
  -- The number of connected screens can be also used.
  if hs.battery.powerSource() == 'AC Power' then
    logger:d('AC Power and turning off DND')
    dnd.turnOffAfterSleep()
  else
    logger:d('No AC Power and turning on DND')
    dnd.turnOn()
  end
end

return dnd
