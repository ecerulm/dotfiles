function vim
	if test -z $argv
    # only if no arguments provided
    if test -e Session.vim
      command vim -S Session.vim
    else
      command vim $argv
    end
  else
      command vim $argv
  end
end
