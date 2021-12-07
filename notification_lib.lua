--
-- Notificaion utils
--

no = {}

function no.alert(msg)
  hs.alert.show(msg)
end

function no.notify(msg)
  hs.notify.new({title="Hammerspoon", informativeText=msg}):send()
end

return no
