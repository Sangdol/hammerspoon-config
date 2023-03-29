--
-- Notificaion utility
--

local no = {}

-- Show on-screen alert
function no.alert(msg)
  return hs.alert.show(msg)
end

-- Show notification
function no.notify(msg)
  return hs.notify.new({title="Hammerspoon", informativeText=msg}):send()
end

return no
