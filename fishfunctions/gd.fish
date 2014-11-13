function gd --description 'git diff, detect renames and copies (can be superslow depending on copy/rename targets)'
	git diff -M -C $argv
end
