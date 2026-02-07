# This is sourced for login shells only
# This is sourced after .zshrc to the PATH is already set
# It is NOT the place for alias definitions, options,
# environment variables, settings, etc. 
#
# Put only comamnds like fortune, msgs, etc

if builtin command -v fortune >/dev/null; then
  fortune
fi

