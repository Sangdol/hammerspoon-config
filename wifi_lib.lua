wf = {}

function wf.isSecond()
  return hs.wifi.interfaceDetails()['security'] == 'WPA2 Personal'
end

return wf
