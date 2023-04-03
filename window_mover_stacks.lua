--
-- Map of stacks for each screen count
--
local stack = require('lib/stack')
local M = {}
local STACK_SIZE = 5

function M.push(windowMap)
  if not windowMap then
    return
  end

  local screenCount = #hs.screen.allScreens()
  local stack = M.getStack(screenCount)
  stack:push(windowMap)
end

function M.pop()
  local screenCount = #hs.screen.allScreens()
  local stack = M.getStack(screenCount)
  return stack:pop()
end

function M.peek()
  local screenCount = #hs.screen.allScreens()
  local stack = M.getStack(screenCount)
  return stack:peek()
end

function M.isEmpty()
  local screenCount = #hs.screen.allScreens()
  local stack = M.getStack(screenCount)
  return stack:isEmpty()
end

function M.getStack(screenCount)
  if not M.stacks then
    M.stacks = {}
  end

  if not M.stacks[screenCount] then
    M.stacks[screenCount] = stack:new(STACK_SIZE)
  end

  return M.stacks[screenCount]
end

return M
