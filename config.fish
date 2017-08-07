#set PATH_ORIG $PATH
#set -gx BASE_PATH /usr/sbin /usr/bin /sbin /bin
#set -gx PATH ~/bin /usr/local/bin /usr/local/sbin $BASE_PATH
if status --is-interactive
  set PATH /usr/local/bin /usr/local/sbin $PATH
  # if test -d ~/anaconda/bin
  #   set PATH ~/anaconda/bin $PATH
  #   set -x OPENSSL_CONF $HOME/anaconda/ssl/openssl.cnf
  # end
  if test -d ~/.rbenv
    set PATH ~/.rbenv/bin $PATH
    . (rbenv init -|psub)
  end
  if test -d ~/bin
    set PATH ~/bin $PATH
  end
  if test -d ~/.local/bin
    set PATH ~/.local/bin $PATH
  end
  if test $COLORTERM = "gnome-terminal"
    set -x TERM xterm-256color
  end

  if test -d ~/miniconda2
    set PATH ~/miniconda2/bin $PATH
  end
  # If pyenv in the PATH
  if test -d ~/.pyenv
    set -gx PYENV_ROOT "$HOME/.pyenv"
    set PATH $PYENV_ROOT/bin $PATH
    . (pyenv init -|psub)
    . (pyenv virtualenv-init -|psub)
  end

  if test -d /usr/local/share/scala-2.12.2/
    set -gx SCALA_HOME /usr/local/share/scala-2.12.2
    set PATH $SCALA_HOME/bin $PATH
  end

  if test -d /usr/local/sbt/
    set -gx SBT_HOME /usr/local/sbt
    set PATH $SBT_HOME/bin $PATH
  end

  if test -d /usr/local/spark-2.1.1-bin-hadoop2.7/
    set -gx SPARK_HOME /usr/local/spark-2.1.1-bin-hadoop2.7
    set PATH $SPARK_HOME/bin $PATH
  end

  set -gx GOPATH ~/go
  set PATH (go env GOPATH)/bin $PATH
  # if test -d ~/local/stow/go1.8
  #   set -gx GOROOT "$HOME/local/stow/go1.8"
  #   set -gx GOPATH "$HOME/go"
  #   set PATH $GOROOT/bin $GOPATH/bin $PATH
  # end

  # If opam in the path
  type opam >/dev/null ^/dev/null
  if test $status -eq 0
    . (opam config env|psub)
  end

  if test -e ~/.config/fish/apikeys
    . ~/.config/fish/apikeys
  end

end # is interactive
set -gx LC_CTYPE "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set BROWSER 'open' # needed for help command to work
set -gx EDITOR vim
set -gx PYTHONSTARTUP ~/.pythonrc
switch (uname)
  case Linux
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
end


stty -ixon  # Disable flow control


