--
-- Do Not Disturb utility
--
-- You need to set up a shortcut to toggle Do Not Disturb to use this script.
-- See the dndKeyStroke() function.
--

local no = require('lib/notification_lib')
local st = require('lib/string_lib')

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
  logger:d('DND On')
  no.alert('DND On')

  if not dnd.isOn() then
    dndKeyStroke()
  end
end

function dnd.turnOff()
  logger:d('DND Off')
  no.alert('DND Off')

  if dnd.isOn() then
    dndKeyStroke()
  end
end

return dnd
