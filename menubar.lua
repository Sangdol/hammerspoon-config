--
-- Textbar replacement
--

local PATH_PREFIX = '$HOME/projects/osx/textbar'
local UPDATE_INTERVAL = 5

local function executeScript(scriptName)
  return st.trim(hs.execute(PATH_PREFIX .. '/' .. scriptName))
end

local menubar = {
  _items = {},
  _add = function(self, name, title, fn)
    local item = hs.menubar.new():setTitle(title)
    item:setClickCallback(fn)
    self._items[name] = item
  end,
  set = function(self, name, title, fn)
    if self._items[name] then
      self._items[name]:setTitle(title)
    else
      self._add(self, name, title, fn)
    end
  end,
  delete = function(self, name)
    if self._items[name] then
      self._items[name]:delete()
      self._items[name] = nil
    end
  end,
}

-- This has to be global not to be garbage collected.
MenubarTimer = hs.timer.new(UPDATE_INTERVAL, function()
  local scripts = {'pomo', 'tea', 'mail-checker', 'youtube-music'}

  for _, scriptname in ipairs(scripts) do
    local result = executeScript(scriptname .. '.sh')

    if result ~= '' then
      menubar:set(scriptname, result)
    else
      menubar:delete(scriptname)
    end
  end
end):start()

