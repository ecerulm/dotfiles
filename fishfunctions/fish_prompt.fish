function fish_prompt --description 'Write out the left prompt'
	
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color -o red)
  set -l blue (set_color blue)
  set -l magenta (set_color -o magenta)
  set -l normal (set_color normal)


  set -l arrow "$red➜" # Red Arrow symbol
  #set -l cwd $cyan(basename (prompt_pwd)) # current working dir in cyan
  set -l cwd $cyan(prompt_pwd) # current working dir in cyan

  if test -n (git_branch_name)
    set -l git_branch $red(git_branch_name)
    set git_info "$blue ($git_branch$blue)"
    
    if [ (is_git_dirty) ]
      set arrow "$red✗"
    end

    if test -n (unpushed)
      set git_info "$git_info$normal with$magenta unpushed"
    end

  end

  #echo -e \n

  set -l rvminfo ''
  type rvm_prompt >/dev/null
  if test $status -eq 0
     set rvminfo (rvm_prompt)
  end
  echo -n -s $rvminfo $cwd $git_info
  echo
  echo -e $arrow $normal
end
