--
-- Table utili functions
--
tl = {}

function tl.print(t)
  for k, v in pairs(t) do
    print(k, ':', v)
  end
end

function tl.printList(t)
  for i=1, #t do
    print(i, ':', t[i])
  end
end

function tl.isInList(t, elem)
  for i=1, #t do
    if t[i] == elem then
      return true
    end
  end

  return false
end

-- https://stackoverflow.com/a/15278426/524588
function tl.concat(t1, t2)
  for i=1, #t2 do
    t1[#t1+1] = t2[i]
  end
  return t1
end

return tl
