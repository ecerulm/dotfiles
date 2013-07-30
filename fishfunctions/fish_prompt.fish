function fish_prompt
  set_color purple
  date "+%m/%d/%y"
  set_color red
  echo (pwd) '>'
  set_color normal
end
