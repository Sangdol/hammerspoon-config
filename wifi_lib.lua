wf = {}

logger = hs.logger.new('wf', 5)

function wf.isSecond()
  return hs.wifi.interfaceDetails()['security'] == 'WPA2 Personal'
end

function wf.isOn()
  return hs.wifi.interfaceDetails()['power']
end

return wf
