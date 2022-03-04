--
-- String Utils
--

st = {}

-- from http://lua-users.org/wiki/StringTrim
function st.trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return st
