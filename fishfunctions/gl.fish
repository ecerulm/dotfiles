function gl --description 'display git pretty log, tabular form'
	set -l HASH "%C(yellow)%h%Creset"
  set -l RELATIVE_TIME "%Cgreen(%ar)%Creset"
  set -l AUTHOR "%C(bold blue)<%an>%Creset"
  set -l REFS "%C(bold red)%d%Creset"
  set -l SUBJECT "%s"

  set -l FORMAT "$HASH}$RELATIVE_TIME}$AUTHOR}$REFS $SUBJECT"


  # git log
	git log --graph --pretty=tformat:$FORMAT $argv| \
  sed -Ee 's/(.*) ago\)/\1)/' | \
  sed -Ee 's/(.*), [[:digit:]]+ .*months?\)/\1)/' | \
  column -t -s "}" | \
  less -FXRS
end
