function vim
	set -l vim_session_opt ''
	if test -e Session.vim
		set vim_session_opt '-S' 'Session.vim'
	end
	command vim $vim_session_opt $argv
end
