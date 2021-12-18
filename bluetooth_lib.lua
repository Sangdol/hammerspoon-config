bt = {}

function bt.connect()
  logger:d("Connecting to bluetooth")
  -- bluetooth.sh: a script to connect to a specific device using blueutil
  hs.execute('$HOME/projects/osx/scripts/bluetooth.sh', true)
end

function bt.conditionallyConnect()
  -- The number of connected screens can be also used.
  if hs.battery.isCharging() then
    bt.connect()
  end
end

function bt.turnOff()
  logger:d("Turning off bluetooth")
  hs.execute('/usr/local/bin/blueutil --power 0', true)
end

return bt
