#set PATH_ORIG $PATH
#set -gx BASE_PATH /usr/sbin /usr/bin /sbin /bin
#set -gx PATH ~/bin /usr/local/bin /usr/local/sbin $BASE_PATH
if status --is-interactive
  set PATH /usr/local/bin /usr/local/sbin $PATH
end
set -gx LC_CTYPE "en_US.UTF-8"
set BROWSER 'open' # needed for help command to work
set -gx EDITOR vim
