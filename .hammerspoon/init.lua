require "credentials"
-- credentials.lua should have the format
-- local modname = ... -- ... is varargs, require passes the module name as as part of the varargs
-- local M = {
--  gistCredentials={
--      token="xxxxxxxx",
--      endpoint="https://api.github.com",
--  },
-- }
-- _G[modname] = M -- we set _G["credentials"] = {...}

Log = hs.logger.new('mymodule', 'debug')

Wf_chrome = hs.window.filter.new('Google Chrome')
Expose_chrome = hs.expose.new(Wf_chrome)

function PrettifyJsonInPasteboard()
  local file = io.open("/Users/rublag/tmp.json", "w")
  file:write(hs.pasteboard.readString())
  file:close()
  hs.execute("/usr/local/bin/jq -S . /Users/rublag/tmp.json > /Users/rublag/tmp2.json")
  file = io.open("/Users/rublag/tmp2.json", "r")
  hs.pasteboard.setContents(file:read("*all"))
end

function FocusAppOnMousePointer(appName)
  local app = hs.application.open(appName, 10, true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
  hs.alert.show("activate " .. appName)
end

function ToggleMuteOnMicrosoftTeams()
  FocusAppOnMousePointer("Microsoft Teams")
  hs.eventtap.keyStroke({ 'cmd', 'shift' }, 'm')
end

function HideApplicationsWithWindowsOnScreen(screen)
  local windows = hs.window.allWindows()

  for _, w in ipairs(windows) do
    if w:screen() == screen then
      w:application():hide()
    end
  end
end

function NoStrongOpinionAudio()
  -- save state
  local currentOutputDevice = hs.audiodevice.defaultOutputDevice()
  local currentVolume       = currentOutputDevice:outputVolume()
  local currentMutedState   = currentOutputDevice:muted()

  -- set audio output to speakers, volume to max and open youtube clip
  local speakers = hs.audiodevice.findOutputByName('MacBook Pro Speakers')
  speakers:setDefaultOutputDevice()
  speakers:setOutputMuted(false)
  speakers:setOutputVolume(100)
  hs.urlevent.openURL('https://www.youtube.com/watch?v=CxK_nA2iVXw')
  hs.timer.doAfter(5.5, function()

    -- restore state
    currentOutputDevice:setDefaultOutputDevice()
    currentOutputDevice:setOuputMuted(currentMutedState)
    currentOutputDevice:setOutputVolume(currentVolume)
  end)
end

-- local l = hs.logger.new('global', 'info')
local hyper = { "cmd", "alt", "ctrl", "shift" }

hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "W", function()
  hs.notify.new({ title = "Hammerspoon", informativeText = "Hello World" }):send()
end)


-- PASTE EVERNOTE / removing formattig / copy and paste
hs.hotkey.bind(hyper, 'a', function() -- remove formatting from pasteboard and paste
  local allData = hs.pasteboard.readAllData()
  local htmlData = allData['public.html']
  allData['public.html'] = nil -- just remove HTML from the pasteboard/clipboard as it's usually the offender
  local rtfData = allData['public.rtf']
  allData['public.rtf'] = nil -- just remove styled text RTF as well
  hs.pasteboard.writeAllData(allData)
  hs.eventtap.keyStroke({ 'cmd' }, 'v')
  hs.alert.show('removed HTML from pasteboard')
  allData['public.html'] = htmlData
  allData['public.rtf'] = rtfData
  hs.timer.doAfter(2, function()
    hs.pasteboard.writeAllData(allData)
    hs.alert.show('restore pasteboard')
  end)
end)

hs.hotkey.bind(hyper, "H", function() -- move window left 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "L", function() -- move window right 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "k", function() -- move window down 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "J", function() -- move window up 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "b", function() -- move window down-right 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "n", function() -- move window down-left 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "y", function() -- move window up-right 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind(hyper, "u", function() -- move window up-left 10 px
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y - 10
  win:setFrame(f)
end)


function MoveWindow(direction)
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local screenframe = screen:frame()
  local winFrame = screen:absoluteToLocal(win:frame())
  local winX = winFrame.x
  local winWidth = winFrame.w
  local screenwidth = math.floor(screenframe.w)

  local np = 3
  local winPartWidth = screenwidth // np

  local arrayOfPositions = {
    { x = 0, width = winPartWidth * 3 }, -- maximize
    { x = 0, width = winPartWidth }, -- left half
    { x = 0, width = screenwidth // 2 }, -- left 1/3
    { x = 0, width = winPartWidth * 2 }, -- left 2/3
    { x = winPartWidth, width = winPartWidth }, -- 1/3 to  2/3
    { x = winPartWidth, width = winPartWidth * 2 }, -- 1/3 to  3/3
    { x = screenwidth // 2, width = screenwidth // 2 }, -- 1/2 to  2/2
    { x = winPartWidth * 2, width = winPartWidth }, -- 2/3 to 3/3
  }

  local currentIndex = 0
  for i, pos in ipairs(arrayOfPositions) do
    -- Log.i(winX, winWidth, pos.x, pos.width)
    if (pos.x == winX and pos.width == winWidth) then
      currentIndex = i
      break
    end
  end

  local targetIndex = currentIndex + direction
  if targetIndex < 1 then
    targetIndex = 1
  end


  if targetIndex > #arrayOfPositions then
    targetIndex = #arrayOfPositions
  end

  winFrame.x = arrayOfPositions[targetIndex].x
  winFrame.w = arrayOfPositions[targetIndex].width
  winFrame.h = screenframe.h
  win:setFrame(winFrame)

end

hs.hotkey.bind(hyper, "Left", function() -- RESIZE WINDOW TO HALF-LEFT / MAXIMIZE LEFT / SPLIT WINDOW / TILE WINDOW
  MoveWindow(-1)
end)


hs.hotkey.bind(hyper, "Right", function() -- RESIZE WINDOW TO HALF-LEFT / MAXIMIZE LEFT / SPLIT WINDOW / TILE WINDOW
  MoveWindow(1)
end)

hs.hotkey.bind(hyper, "Up", function() -- MAXIMIZE CURRENT WINDOW
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)

end)

hs.hotkey.bind(hyper, "R", function() -- RELOAD HAMMERSPOON CONFIG
  hs.alert.show("Reloading config", 2)
  -- hs.timer.usleep(20000 * 1000) -- logitech gaming software will keep the hyper key pressed for 25 milliseconds I think so that will interfere with the Cmd-v below
  hs.reload()
end)

hs.hotkey.bind(hyper, 'X', function() -- PRETTIFY JSON IN CLIPBOARD
  PrettifyJsonInPasteboard()
  hs.alert.show("clipboard update with prettified JSON")
end)

hs.hotkey.bind(hyper, 'V', function() -- CREATE A GIST WITH THE CONTENTS OF PASTEBOARD
  -- https://developer.github.com/v3/gists/#create-a-gist
  -- authentication https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/
  -- Oath scope : gist
  -- GitHub > Settings > Developer settings > Personal access token
  -- hs.http https://www.hammerspoon.org/docs/hs.http.html
  -- hs.json https://www.hammerspoon.org/docs/hs.json.html
  local data = {
    files = {
      ["file1.txt"] = {
        content = hs.pasteboard.readString()
      }
    }
  }
  local json = hs.json.encode(data, true)
  -- is.dialog.blockAlert(json, "json is")
  local headers = {
    ["Authorization"] = "token " .. credentials.gistCredentials.token,
    ["Accept"] = "application/vnd.github.v3+json",
  }

  hs.alert.show("credentials.gistCredentials.endpoint " .. credentials.gistCredentials.endpoint)
  -- hs.alert.show("headers " .. headers)
  hs.alert.show("credentials.gistCredentials.token  " .. credentials.gistCredentials.token)

  local code, body, _ = hs.http.post(credentials.gistCredentials.endpoint .. "/gists", json, headers)
  -- hs.alert.show("code " .. code)
  -- hs.alert.show("ruben")
  -- hs.alert.show("body " .. body)
  -- hs.alert.show("headers " .. headers)
  local response = hs.json.decode(body)

  hs.alert.show("POST gist returned" .. code)
  if (code ~= 201) then
    hs.pasteboard.setContents(json)
    hs.dialog.blockAlert(response, "code: " .. code)
  else
    local html_url = response.html_url
    hs.pasteboard.setContents(html_url)
    hs.alert.show("gist url " .. html_url .. " copied to pasteboard")
    hs.urlevent.openURL(html_url)
  end
end)

hs.hotkey.bind(hyper, 'C', function() -- SCREENSHOT TO EVERNOTE
  hs.task.new("/usr/sbin/screencapture",
    function()
      hs.application.get('Evernote'):activate()
      hs.eventtap.keyStroke({ "cmd" }, "v")
      hs.eventtap.keyStrokes(" \n")

      hs.alert.show("clipboard pasted to evernote")
    end,
    { "-ci" }
  ):start()
end)

hs.hotkey.bind({ "alt", "ctrl", "shift" }, 'C', function() -- SCREENSHOT TO PASTEBOARD
  hs.task.new("/usr/sbin/screencapture",
    function()
      hs.alert.show("screenshot pasted to pasteboard")
    end,
    { "-ci" }
  ):start()
end)


-- Hyper keys

hs.hotkey.bind(hyper, '1', function() -- Neutral : I have no strong feelings one way or the other
  NoStrongOpinionAudio()
end)

hs.hotkey.bind(hyper, '2', function() -- iTunes play pause / Music play pause
  hs.itunes.playpause()
end)

hs.hotkey.bind(hyper, '3', function() -- iTunes next / Music.app next
  hs.itunes.next()
end)

hs.hotkey.bind(hyper, '5', function() -- Google Chrome
  FocusAppOnMousePointer("Google Chrome")
end)

hs.hotkey.bind(hyper, '6', function() -- Microsoft Teams
  FocusAppOnMousePointer("Microsoft Teams")
end)

-- Open Evernote
hs.hotkey.bind(hyper, '7', function() -- EVERNOTE
  --focusAppOnMousePointer("Evernote")
  local app = hs.application.open("Evernote", 10, true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
  hs.eventtap.keyStroke({ "fn", "control" }, "down") -- Mission control for this app only
end)

-- hs.hotkey.bind(hyper, '8', function() -- SLACK
--   focusAppOnMousePointer("Slack")
-- end)

hs.hotkey.bind(hyper, '8', function() -- PyCharm
  FocusAppOnMousePointer("PyCharm")
end)

-- hs.hotkey.bind(hyper, '9', function() -- iTerm2
--   hs.alert.show("test iTerm2")
--   local app = hs.application.open(appName, 10,true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
-- end)

--hs.hotkey.bind(hyper, '0', toggleMuteOnMicrosoftTeams)
hs.hotkey.bind(hyper, '0', function()
  -- local app = hs.application.open("Google Chrome",5,true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
  local app = hs.application.open("com.google.Chrome", 5, true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
  -- hs.alert.show("application name " .. app:name())
  -- hs.alert.show("bundleID " .. app:bundleID())
  app:activate(true)
  hs.eventtap.keyStroke({ "fn", "control" }, "down")
end)


hs.hotkey.bind(hyper, '-', function()
  hs.alert.show("activate iTerm2")
  local app = hs.application.open("com.googlecode.iterm2", 10, true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
  app:activate()
  hs.eventtap.keyStroke({ "fn", "control" }, "down")
end)


hs.hotkey.bind(hyper, 'e', function()
  hs.alert.show("Search evernote")
  local evernoteapp = hs.application.open("com.evernote.Evernote", 10, true) -- Launches an application or activates if already running, waits for first window to appear at least 10 seconds
  --evernoteapp:activate(true) -- https://www.hammerspoon.org/docs/hs.application.html#activate
  --evernoteapp:mainWindow():focus()
  hs.eventtap.keyStroke({ "cmd", "ctrl" }, "e")
  local mytimer = hs.timer.doAfter(0.3, function()
    hs.eventtap.keyStroke({ "cmd" }, hs.keycodes.map.delete)
    local mytimer2 = hs.timer.doAfter(0.3, function()
      --hs.eventtap.keyStrokes("hello") -- https://www.hammerspoon.org/docs/hs.eventtap.html#keyStrokes
      --hs.eventtap.keyStroke({"cmd"}, "x",500000,evernoteapp)

      -- newKeyEvent: https://www.hammerspoon.org/docs/hs.eventtap.event.html#newKeyEvent
      hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, true):post()
      hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, true):post()
      hs.eventtap.event.newKeyEvent("1", true):post()
      hs.eventtap.event.newKeyEvent("1", false):post()
      hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, false):post()
      hs.eventtap.event.newKeyEvent(hs.keycodes.map.cmd, false):post()
      hs.eventtap.keyStroke({ "cmd", "ctrl" }, "e")

    end)
  end)
end)
