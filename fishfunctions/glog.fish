function glog --description 'git log one line no graph'
	git log --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset" $argv
end
