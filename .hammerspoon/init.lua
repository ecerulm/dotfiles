require "credentials"

local hyper = {"cmd", "alt", "ctrl", "shift"}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
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


hs.hotkey.bind(hyper, "Left", function() -- RESIZE WINDOW TO HALF-LEFT
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)

end)


hs.hotkey.bind(hyper, "Right", function() -- RESIZE WINDOW TO HALF-RIGHT
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
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
-- hs.alert.show("Reloading config")
hs.reload()
end)

hs.hotkey.bind(hyper, 'X', function() -- PRETTIFY JSON IN CLIPBOARD
  prettifyJsonInPasteboard()
  hs.alert.show("clipboard update with prettified JSON")
end)

function prettifyJsonInPasteboard()
  local file = io.open("/Users/rublag/tmp.json", "w")
  file:write(hs.pasteboard.readString())
  file:close()
  hs.execute("/usr/local/bin/jq -S . /Users/rublag/tmp.json > /Users/rublag/tmp2.json")
  file = io.open("/Users/rublag/tmp2.json", "r")
  hs.pasteboard.setContents(file:read("*all"))
end

hs.hotkey.bind(hyper, 'V', function() -- CREATE A GIST WITH THE CONTENTS OF PASTEBOARD
  -- https://developer.github.com/v3/gists/#create-a-gist
  -- authentication https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/
  -- Oath scope : gist
  -- GitHub > Settings > Developer settings > Personal access token
  -- hs.http https://www.hammerspoon.org/docs/hs.http.html
  -- hs.json https://www.hammerspoon.org/docs/hs.json.html
  local data = {
    files={
      ["file1.txt"]={
        content=hs.pasteboard.readString()
      }
    }
  }
  local json = hs.json.encode(data,true)
  -- is.dialog.blockAlert(json, "json is")
  local headers = {
    ["Authorization"]="token " .. credentials.gistCredentials.token
  }

  hs.alert.show("credentials.gistCredentials.endpoint " .. credentials.gistCredentials.endpoint)
  -- hs.alert.show("headers " .. headers)
  hs.alert.show("credentials.gistCredentials.token  " .. credentials.gistCredentials.token)

  local code, body, headers = hs.http.post(credentials.gistCredentials.endpoint, json, headers)
  -- hs.alert.show("code " .. code)
  -- hs.alert.show("ruben")
  -- hs.alert.show("body " .. body)
  -- hs.alert.show("headers " .. headers)
  local response = hs.json.decode(body)

  hs.alert.show("POST gist returned" .. code)
  if ( code ~= 201) then
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
    hs.eventtap.keyStroke({"cmd"}, "v")
    hs.eventtap.keyStrokes(" \n")

    hs.alert.show("clipboard pasted to evernote")
  end,
  {"-ci"}
  ):start()
end)

hs.hotkey.bind({"alt", "ctrl", "shift"}, 'C', function() -- SCREENSHOT TO PASTEBOARD
hs.task.new("/usr/sbin/screencapture",
  function()
    hs.alert.show("screenshot pasted to pasteboard")
  end,
  {"-ci"}
  ):start()
end)

hs.hotkey.bind(hyper, '7', function() -- EVERNOTE
  focusAppOnMousePointer("Evernote")
end)


hs.hotkey.bind(hyper, '8', function() -- SLACK
  focusAppOnMousePointer("Slack")
end)

hs.hotkey.bind(hyper, '9', function() -- iTerm2
  focusAppOnMousePointer("iTerm2")
end)

hs.hotkey.bind(hyper, '1', function() -- I have no strong feelings one way or the other
  noStrongOpinionAudio()
end)

function focusAppOnMousePointer(appName)
  local screen = hs.mouse.getCurrentScreen() -- http://www.hammerspoon.org/docs/hs.mouse.html#getCurrentScreen
  local screenFrame = screen:frame()
  -- hideApplicationsWithWindowsOnScreen(screen) -- hide all other windows


  local app = hs.application.get(appName)
  local mainWindow = app:mainWindow() -- http://www.hammerspoon.org/docs/hs.window.html
  mainWindow:moveToScreen(screen) -- https://www.hammerspoon.org/docs/hs.window.html#moveToScreen
  local f = hs.geometry.copy(screenFrame) -- http://www.hammerspoon.org/docs/hs.geometry.html#copy
  -- screenFrame x,y is relative to the mainWindow so if the screen is to the left of the mainWindow .x will be negative
  f.x = f.x + screenFrame.w * 1/6
  f.y = f.y
  -- f.w = f.w*4/5
  f.w = f.w - 50
  f.h = f.h - 50
  mainWindow:setFrameInScreenBounds(f) -- https://www.hammerspoon.org/docs/hs.window.html#setFrameInScreenBounds
  app:activate()
  hs.alert.show("activate " .. appName)
end

function hideApplicationsWithWindowsOnScreen(screen)
  local windows = hs.window.allWindows()

  for i,w in ipairs(windows) do
    if w:screen() == screen then
      w:application():hide()
    end
  end
end

function noStrongOpinionAudio()
  -- save state
  local currentOutputDevice = hs.audiodevice.defaultOutputDevice()
  local currentVolume  = currentOutputDevice:outputVolume()
  local currentMutedState = currentOutputDevice:muted()

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