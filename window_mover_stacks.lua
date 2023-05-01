--
-- Map of stacks for each screen count
--
local logger = hs.logger.new('win_stack', 'debug')
local stack = require('lib/stack')
local M = {}
local STACK_SIZE = 5


function M.push(item)
  if not item then
    error('item is nil')
    return
  end

  local stack = M.getStack()
  stack:push(item)
end

function M.pop()
  local stack = M.getStack()
  return stack:pop()
end

function M.peek()
  local stack = M.getStack()
  return stack:peek()
end

function M.isEmpty()
  local stack = M.getStack()
  return stack:isEmpty()
end

function M.size()
  local stack = M.getStack()
  return stack:size()
end

function M.getStack()
  if not M.stacks then
    M.stacks = {}
  end

  local screenCount = #hs.screen.allScreens()
  logger:d('Getting Stack for screen count: ' .. screenCount)

  if not M.stacks[screenCount] then
    M.stacks[screenCount] = stack:new(STACK_SIZE)
  end

  return M.stacks[screenCount]
end

return M
