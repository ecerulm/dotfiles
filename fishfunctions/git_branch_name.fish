function git_branch_name -d "Write out the git branch name"
  echo (git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end
