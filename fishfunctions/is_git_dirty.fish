function is_git_dirty -d "Write out Git dirty / not dirty status"
  echo (git status -s --ignore-submodules=dirty ^/dev/null)
end
