--
-- Hammerspoon wifi wrapper
-- https://www.hammerspoon.org/docs/hs.wifi.html
--

local wf = {}
local logger = hs.logger.new('Wifi', 5)

function wf.isOn()
  return hs.wifi.interfaceDetails()['power']
end

function wf.turnOn()
  local res = hs.wifi.setPower(true)
  logger:d('Turning on wifi...', res)
end

function wf.turnOff()
  local res = hs.wifi.setPower(false)
  logger:d('Turning off wifi...', res)
end

function wf.details()
  tl.show(hs.wifi.interfaceDetails())
end

return wf
