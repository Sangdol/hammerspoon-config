tl = require('table_lib')

wf = {}

logger = hs.logger.new('Wifi', 5)

function wf.isSecond()
  return hs.wifi.interfaceDetails()['security'] == 'WPA2 Personal'
end

function wf.isOn()
  return hs.wifi.interfaceDetails()['power']
end

function wf.turnOn()
  logger:d('Turning on wifi...')
  hs.wifi.setPower(true)
end

function wf.turnOff()
  logger:d('Turning off wifi...')
  hs.wifi.setPower(false)
end

function wf.details()
  tl.show(hs.wifi.interfaceDetails())
end

return wf
