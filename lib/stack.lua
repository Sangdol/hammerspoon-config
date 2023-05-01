--
-- Stack with a fixed size
--
local stack = {}

function stack:new(maxSize)
    local obj = {}
    obj.items = {}
    obj.maxSize = maxSize or math.huge
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function stack:push(item)
    if #self.items >= self.maxSize then
        table.remove(self.items, 1)
    end
    table.insert(self.items, item)
end

function stack:pop()
    return table.remove(self.items)
end

function stack:peek()
    return self.items[#self.items]
end

function stack:isEmpty()
    return #self.items == 0
end

function stack:size()
    return #self.items
end

return stack

