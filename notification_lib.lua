--
-- Notificaion utils
--

no = {}

function no.alert(msg)
  return hs.alert.show(msg)
end

function no.notify(msg)
  return hs.notify.new({title="Hammerspoon", informativeText=msg}):send()
end

return no
