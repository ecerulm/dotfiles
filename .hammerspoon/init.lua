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


hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Left", function()
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

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "Right", function()
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


hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "R", function()
hs.reload()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, 'X', function()
  local file = io.open("/Users/rublag/tmp.json", "w")
  file:write(hs.pasteboard.readString())
  file:close()
  hs.execute("/usr/local/bin/jq . /Users/rublag/tmp.json > /Users/rublag/tmp2.json")
  file = io.open("/Users/rublag/tmp2.json", "r")
  hs.pasteboard.setContents(file:read("*all"))
  hs.alert.show("clipboard update with prettified JSON")
end)


hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, 'C', function()
hs.task.new("/usr/sbin/screencapture",
  function()
    hs.application.get('Evernote'):activate()
    hs.eventtap.keyStroke({"cmd"}, "v")
    hs.alert.show("clipboard pasted to evernote")
  end,
  {"-ci"}
  ):start()
end)

hs.hotkey.bind({"alt", "ctrl", "shift"}, 'C', function()
hs.task.new("/usr/sbin/screencapture",
  function()
    hs.alert.show("screenshot pasted to pasteboard")
  end,
  {"-ci"}
  ):start()
end)
