--
-- Textbar replacement
--

local logger = hs.logger.new('menubar', 'info')

local home = os.getenv('HOME')
local PATH_PREFIX = home .. '/projects/osx/textbar'
local UPDATE_INTERVAL = 5

--
-- This function adds a menubar item or updates it if it already exists.
-- Setting the order of the items is not straightforward 
-- as it is determined by the order of their creation.
--
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

local function scriptPath(scriptname)
  return PATH_PREFIX .. '/' .. scriptname .. '.sh'
end

-- This has to be global not to be garbage collected.
MenubarTimer = hs.timer.new(UPDATE_INTERVAL, function()
  local scripts = {'pomo', 'tea', 'mail-checker', 'audio-output'}

  -- Macbook menubar is too crowded for youtube-music.
  if Global.screenCount > 1 then
    table.insert(scripts, 'youtube-music')
  else
    menubar:delete('youtube-music')
  end 

  for _, scriptname in ipairs(scripts) do
    hs.task.new(scriptPath(scriptname), function(exitCode, stdOut, stdErr)
      if exitCode ~= 0 then
        logger:e("Error executing " .. scriptname .. ": " .. stdErr)
      else
        local result = stdOut
        logger:d("Result of " .. scriptname .. ": " .. result)
        if result ~= '' then
          menubar:set(scriptname, st.trim(result))
        else
          menubar:delete(scriptname)
        end
      end
    end):start()
  end
end):start()
