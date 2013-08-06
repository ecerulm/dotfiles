function lsgitrepos --description 'List Git repositories at rubenlaguna.com'
	ssh -q rubenlaguna.com 'ls ~/git'
end
