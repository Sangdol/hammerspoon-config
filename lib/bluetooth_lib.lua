--
-- Bluetooth lib
--
-- This script is dependent on blueutil and my custom bash script that uses blueutil.
-- blueutil: https://github.com/toy/blueutil
--
local bt = {}

local logger = hs.logger.new('BT_lib', 'debug')

function bt.connect()
  logger:i("Connecting to bluetooth")
  -- bluetooth.sh: a script to connect to a specific device using blueutil
  hs.execute('$HOME/projects/osx/scripts/bluetooth.sh', true)
end

-- This can be used to connect to a bluetooth device only when the laptop is connected to AC Power.
-- This is useful when you want to use a bluetooth keyboard and mouse only when you are at your desk.
function bt.conditionallyConnect()
  -- The number of connected screens can be also used.
  if hs.battery.powerSource() == 'AC Power' then
    logger:d('AC Power and connecting to BT')
    -- What's the latency of this?
    bt.connect()
  else
    logger:d('No AC Power and skipping BT')
  end
end

function bt.turnOff()
  logger:i("Turning off bluetooth")
  hs.execute('/opt/homebrew/bin/blueutil --power 0', true)
end

return bt
