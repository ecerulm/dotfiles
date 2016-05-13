function vim
	set VIM /usr/bin/vim
  if test -e /Applications/MacVim.app/Contents/MacOS/Vim
     set VIM /Applications/MacVim.app/Contents/MacOS/Vim
  end
  if test -e /usr/local/bin/vim
     set VIM /usr/local/bin/vim
  end
  if test -e ~/.local/bin/vim
     set VIM $HOME/.local/bin/vim
  end

  set VIM vim

	if test -z $argv
    # only if no arguments provided
    if test -e Session.vim
      eval command $VIM -S Session.vim
    end
  end
  eval command $VIM $argv
end
