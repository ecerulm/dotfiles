function rvm_prompt
  set -l yellow (set_color -o yellow)
  if type -t rvm >/dev/null
    set -l identifier (rvm tools identifier)
    echo "$yellow$identifier "
  else
    echo ""
  end
end