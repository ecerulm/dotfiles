#function fish_prompt
#  set_color purple
#  date "+%m/%d/%y"
#  set_color red
#  echo (pwd) (whoami) '>'
#  set_color normal
#end
function fish_prompt -d "Write out the left prompt"
  printf "%s >" (prompt_pwd)
end 
