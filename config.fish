#set PATH_ORIG $PATH
#set -gx BASE_PATH /usr/sbin /usr/bin /sbin /bin
#set -gx PATH ~/bin /usr/local/bin /usr/local/sbin $BASE_PATH
if status --is-interactive
  set PATH /usr/local/bin /usr/local/sbin $PATH
  if test -d ~/anaconda/bin
    set PATH ~/anaconda/bin $PATH
    set -x OPENSSL_CONF $HOME/anaconda/ssl/openssl.cnf
  end
  if test -d ~/.rbenv
    set PATH ~/.rbenv/bin $PATH
    . (rbenv init -|psub)
  end
  if test -d ~/bin
    set PATH ~/bin $PATH
  end
  if test $COLORTERM = "gnome-terminal"
    set -x TERM xterm-256color
  end
end
set -gx LC_CTYPE "en_US.UTF-8"
set BROWSER 'open' # needed for help command to work
set -gx EDITOR vim
set -gx PYTHONSTARTUP ~/.pythonrc
switch (uname)
  case Linux
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
end
