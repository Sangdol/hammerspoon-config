--
-- Device info
--

local di = {}

function di.isHugh()
  return hs.host.localizedName() == 'Hugh’s MacBook Pro'
end

return di
