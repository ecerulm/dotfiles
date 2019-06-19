require "credentials"

local hyper = {"cmd", "alt", "ctrl", "shift"}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
  end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "H", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "L", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "k", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "J", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "b", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "n", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y + 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "y", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x - 10
  f.y = f.y - 10
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "u", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + 10
  f.y = f.y - 10
  win:setFrame(f)
end)


hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Left", function() -- RESIZE WINDOW TO HALF-LEFT
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


hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Right", function() -- RESIZE WINDOW TO HALF-RIGHT
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

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Up", function() -- MAXIMIZE CURRENT WINDOW
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

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "R", function() -- RELOAD HAMMERSPOON CONFIG
hs.reload()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, 'X', function() -- PRETTIFY JSON IN CLIPBOARD
  prettifyJsonInPasteboard()
  hs.alert.show("clipboard update with prettified JSON")
end)

function prettifyJsonInPasteboard()
  local file = io.open("/Users/rublag/tmp.json", "w")
  file:write(hs.pasteboard.readString())
  file:close()
  hs.execute("/usr/local/bin/jq . /Users/rublag/tmp.json > /Users/rublag/tmp2.json")
  file = io.open("/Users/rublag/tmp2.json", "r")
  hs.pasteboard.setContents(file:read("*all"))
end

hs.hotkey.bind(hyper, 'V', function() -- CREATE A GIST WITH THE CONTENTS OF PASTEBOARD
  -- https://developer.github.com/v3/gists/#create-a-gist
  -- authentication https://developer.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/
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
  --hs.dialog.blockAlert(json, "json is")
  local headers = {
    ["Authorization"]="token " .. credentials.gistCredentials.token
  }


  local code, body, headers = hs.http.post(credentials.gistCredentials.endpoint, json, headers)
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

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, 'C', function() -- SCREENSHOT TO EVERNOTE
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

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, '7', function() -- EVERNOTE
  focusAppOnMousePointer("Evernote")
end)


hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, '8', function() -- SLACK
  focusAppOnMousePointer("Slack")
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, '9', function() -- SLACK
  focusAppOnMousePointer("iTerm2")
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
  f.w = f.w*2/3
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
