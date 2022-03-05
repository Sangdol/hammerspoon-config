--
-- Bluetooth lib
--
-- This script is dependent on my custom bash script and blueutil.
-- blueutil: https://github.com/toy/blueutil
--
bt = {}

local logger = hs.logger.new('BT_lib', 'debug')

function bt.connect()
  logger:i("Connecting to bluetooth")
  -- bluetooth.sh: a script to connect to a specific device using blueutil
  hs.execute('$HOME/projects/osx/scripts/bluetooth.sh', true)
end

function bt.conditionallyConnect()
  -- The number of connected screens can be also used.
  if hs.battery.powerSource() == 'AC Power' then
    logger:d('AC Power and connecting to BT')
    bt.connect()
  else
    logger:d('No AC Power and skipping BT')
  end
end

function bt.turnOff()
  logger:i("Turning off bluetooth")
  hs.execute('/usr/local/bin/blueutil --power 0', true)
end

return bt
