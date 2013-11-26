rvm > /dev/null
set -gx PATH ~/bin /usr/local/bin $PATH
set -gx LC_CTYPE "en_US.UTF-8"
set -xU CFLAGS "-g -Wall -Werror -O3 -std=gnu11"
set BROWSER 'open' # needed for help command to work
set EDITOR vim
