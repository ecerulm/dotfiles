function echo_git_clone -d "Write out the git clone cmds for each repo in rubenlaguna.com"
   for i in (lsgitrepos)
     echo "git clone ssh://ecerulm@rubenlaguna.com/~/git/$i"
   end
	
end
