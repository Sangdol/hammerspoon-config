--
-- Table util functions
--
-- Refer to https://www.hammerspoon.org/docs/hs.fnutils.html
--
tl = {}

function tl.print(t)
  for k, v in pairs(t) do
    print(k, ':', v)
  end
end

tl.show = tl.print

function tl.printList(t)
  for i=1, #t do
    print(i, ':', t[i])
  end
end

tl.showList = tl.printList

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

-- https://stackoverflow.com/questions/1252539/most-efficient-way-to-determine-if-a-lua-table-is-empty-contains-no-entries
function tl.empty(t)
  return next(t) == nil
end

return tl
