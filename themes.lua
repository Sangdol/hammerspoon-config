--
-- iTerm and vim theme craziness
--
-- Miro: https://miro.com/app/board/uXjVNcjz7WM=/?moveToWidget=3458764579352079522&cot=14
--

local logger = hs.logger.new('themes', 'info')
local themeFilePath = os.getenv("HOME") .. "/.sang_storage/theme"

--
-- Setting theme
--

-- Write the current theme to the file
local function writeCurrentTheme(style)
  local file, err = io.open(themeFilePath, "w")
  if not file then
    logger:e("Failed to open file: " .. err)
    return false
  end

  if style == "dark" then
    file:write("dark")
  elseif style == "light" then
    file:write("light")
  else
    logger:e("Invalid argument: " .. style)
  end
  file:close()
end

-- Select the iTerm2 profile by sending a key event
local function selectiTermProfile(color)
  local itermKey = "W"

  if color == "light" then
    itermKey = "E"
  end

  hs.eventtap.keyStroke({"ctrl", "alt", "shift", "cmd"}, itermKey)
end

-- Select the vim color scheme by sending a key event
local function selectVimColorsceme(color)
  local vimKey = "["

  if color == "light" then
    vimKey = "]"
  end

  hs.eventtap.keyStroke({}, "space")
  hs.eventtap.keyStroke({}, "e")
  hs.eventtap.keyStroke({}, vimKey)
end

local function toggleTheme(color)
  return function()
    writeCurrentTheme(color)
    selectiTermProfile(color)
    selectVimColorsceme(color)
  end
end

hs.hotkey.bind({"ctrl", "shift", "alt"}, "[", toggleTheme("dark"))
hs.hotkey.bind({"ctrl", "shift", "alt"}, "]", toggleTheme("light"))

--
-- Auto profile change
--

IsAutoProfileEnabled = true

hs.hotkey.bind({"ctrl", "shift", "alt", "cmd"}, "A", function()
    IsAutoProfileEnabled = not IsAutoProfileEnabled
    local status = IsAutoProfileEnabled and "enabled" or "disabled"
    hs.alert.show("Auto profile change " .. status)
end)

local function isITerm2()
  local frontApp = hs.application.frontmostApplication()
  return frontApp and frontApp:name() == "iTerm2"
end

local function autoSelectiTermProfile()
  if not isITerm2() then
    return
  end

  if not IsAutoProfileEnabled then
    return
  end

  local file, err = io.open(themeFilePath, "r")
  if not file then
    logger:e("Failed to open file: " .. err)
    return
  end

  local theme = st.trim(file:read("*a"))
  if theme == "dark" then
    selectiTermProfile("dark")
  elseif theme == "light" then
    selectiTermProfile("light")
  else
    hs.alert.show("The content '" .. theme .. "' is neither 'dark' nor 'light'.")
  end
end

EventTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local flags = event:getFlags()
  local keyCode = event:getKeyCode()

  -- Return if no modifier key is pressed
  if not flags or flags:containExactly({}) then
    return false
  end

  local keyCombinations = {
    {{"cmd"}, "1"},
    {{"cmd"}, "2"},
    {{"cmd"}, "3"},
    {{"cmd"}, "4"},
    {{"cmd"}, "5"},
    {{"cmd"}, "6"},
    {{"cmd"}, "7"},
    {{"cmd"}, "8"},
    {{"cmd"}, "9"},
    {{"cmd"}, "`"},
    {{"cmd"}, "D"},
    {{"cmd"}, "T"},
    {{"Ctrl"}, "D"},
  }

  for _, combo in ipairs(keyCombinations) do
    local modifiers, key = combo[1], combo[2]
    if flags:containExactly(modifiers) and keyCode == hs.keycodes.map[key] then
      autoSelectiTermProfile()
      return false -- Allow the original key event to propagate
    end
  end

  return false
end):start()
