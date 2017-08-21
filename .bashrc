# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

function debug() {
  [ -n "$debug" ] && echo " debug: $@"
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ "$COLORTERM" == "gnome-terminal" ]; then
  export TERM=xterm-256color
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias vi=vim

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Go / Golang
export GOPATH="$HOME/go"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

for BINDIR in $HOME/.local/bin $HOME/.local/sbin; do
  if [ -d "$BINDIR" ]; then
    export PATH="$BINDIR:$PATH"
  fi
done

export PATH="$GOPATH/bin:$PATH"

# added by Anaconda 2.1.0 installer
# if [ -d "/home/ecerulm/anaconda/bin" ]; then
#   export PATH="/home/ecerulm/anaconda/bin:$PATH"
# fi

export EDITOR=vim
alias vi=vim
alias tmux="tmux -2"
alias pyenvreq='sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils '
alias pyenvreqosx='brew install xz readline' # https://github.com/yyuu/pyenv/wiki/Common-build-problems
alias pyenvinstall="git clone https://github.com/yyuu/pyenv.git ~/.pyenv && git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv"
alias pyenvupdate="cd ~/.pyenv && git pull && cd plugins/pyenv-virtualenv && git pull"
alias pyenvinstall27="env CONFIGURE_OPTS='--enable-shared' pyenv install 2.7.12"
alias pyenvinstall27osx="env CONFIGURE_OPTS='' pyenv install 2.7.12"
alias pyenvinstall35="env CONFIGURE_OPTS='--enable-shared' pyenv install 3.5.2"
alias pyenvinstall36="installpythonprereq; env CONFIGURE_OPTS='--enable-shared' pyenv install 3.6.2"
alias pyenvansible="pyenv virtualenv 2.7.12 venv-ansible; pyenv shell venv-ansible && pip install ansible"
alias ansible="~/.pyenv/versions/venv-ansible/bin/ansible"
function contextinstall {
  sudo apt-get install -y rsync ruby zip curl ghostscript graphicsmagick mupdf inkscape pstoedit
}
alias leininstall="sudo apt-get install -y openjdk-8-jdk openjfx && wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O ~/.local/bin/lein && chmod a+x ~/.local/bin/lein && lein"
alias dockerip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias dockerips="docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' \$(docker ps -aq)"
alias s="git st"
alias gdc="git dc"
alias gd="git d"
alias gc="git commit -v"
alias gau="git a" # git add -u
alias gap="git a -p"
alias packages2install="curl -k https://gist.githubusercontent.com/ecerulm/be59ec62ad77178d61a5/raw | sh"

function gl {
  git l
}

function rtags {
  Rscript -e 'rtags(path="./", recursive=TRUE, ofile="RTAGS")' -e 'etags2ctags("RTAGS", "rtags")' -e 'unlink("RTAGS")'
}

function dotfiles {
  cd ~/dotfiles
  s
}

function globalrtags {
  ctags --languages=C,Fortran,Java,Tcl -R -f ~/.cache/Nvim-R/RsrcTags ~/.Renv/versions/3.3.1/   # index the R interpreter source code (.c file, etc)
  Rscript -e 'rtags(path="~/.Renv/versions/3.3.1/", recursive=TRUE, ofile="~/.cache/Nvim-R/RTAGS")' -e 'etags2ctags("~/.cache/Nvim-R/RTAGS", "~/.cache/Nvim-R/Rtags")'
}

function port2process {
  # Access parameters $1, $2, ${$1:mydefaultvalue}
  sudo netstat -nlp | grep ${1:-5001}
  sudo lsof -i :${1:-5001} | grep LISTEN
}
alias port=port2process

alias dockerrmall="docker rm \$(docker ps -qa)"

function tpminstall {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function selfsignedcert {
  openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 3650 -nodes -sha256 -subj '/CN=localhost'
}

pyenvsetupjupytervenv() {
set -euxo pipefail
pyenv virtualenv 2.7.12 venv-jupyter
pyenv shell venv-jupyter
pip install -U pip
pip install jupyter numpy scikit-learn matplotlib pandas scipy
}

jupyternotebookserver() {
pyenv shell venv-jupyter
cd ~/Dropbox/JupyterNotebooks/
jupyter-notebook
}


PYENV_ROOT="$HOME/.pyenv"

if [ -d $PYENV_ROOT ]; then
  export PYENV_ROOT
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1

  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

RENV_ROOT="$HOME/.Renv"
if [ -d "$RENV_ROOT" ]; then
  export RENV_ROOT
  export PATH="$RENV_ROOT/bin:$PATH"

  eval "$(Renv init -)"
fi

GOROOT="$HOME/.local/stow/go1.8"
if [ -d "$GOROOT" ]; then
  export GOROOT
  export PATH="$GOROOT/bin:$PATH"
fi

if [ -f ~/.credentials.bash ]; then
  . ~/.credentials.bash
fi

if [ -f ~/.bashrc.extra ]; then
  . ~/.bashrc.extra
fi

for HADOOP_HOME in "$HOME/.local/stow/hadoop-2.8.1"  '/usr/local/Cellar/hadoop/2.8.0' '/usr/local/hadoop-2.8.1'; do
  debug "Checking HADOOP_HOME=$HADOOP_HOME"
  if [ -d "$HADOOP_HOME" ]; then
    debug "Setting HADOOP_HOME=$HADOOP_HOME"
    export HADOOP_HOME
    export HADOOP_PREFIX=$HADOOP_HOME
    export HADOOP_MAPRED_HOME=$HADOOP_HOME
    export HADOOP_COMMON_HOME=$HADOOP_HOME
    export HADOOP_HDFS_HOME=$HADOOP_HOME
    export HADOOP_YARN_HOME=$HADOOP_HOME
    export YARN_HOME==$HADOOP_HOME
    export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
    export YARN_CONF_DIR=$HADOOP_CONF_DIR
    export PATH="$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH"
    break
  fi
done

for HIVE_HOME in "$HOME/.local/stow/apache-hive-1.1.0-bin/"  "$HOME/.local/stow/apache-hive-1.3.0-bin/"; do
  debug "Checking for HIVE_HOME=${HIVE_HOME}"
  if [ -d "$HIVE_HOME" ]; then
    debug "Setting  HIVE_HOME=${HIVE_HOME}"
    export HIVE_HOME
    export PATH="$HIVE_HOME/bin:$PATH"
    break
  fi
done

function hadoopdl {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
  if [ ! -f "hadoop-2.8.1.tar.gz" ]; then
    curl -O http://apache.mirrors.spacedump.net/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz
    curl -O https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-2.8.1/hadoop-2.8.1.tar.gz.asc
    curl https://dist.apache.org/repos/dist/release/hadoop/common/KEYS >HADOOP-KEYS
    gpg --import HADOOP-KEYS
    gpg --verify hadoop-2.8.1.tar.gz.asc
  fi
}

function hivedl {
  if [ ! -f "hive-2.3.0-bin.tar.gz" ]; then
    curl -O http://apache.mirrors.spacedump.net/hive/hive-2.3.0/apache-hive-2.3.0-bin.tar.gz
  fi
}

function clouderaquickstart {
  # docker pull cloudera/quickstart:latest
  #docker run --hostname=quickstart.cloudera --privileged=true -t -i cloudera/quickstart /usr/bin/docker-quickstart
  docker run --hostname=quickstart.cloudera --privileged=true -t -i -v $HOME/clouderaquickstart:/src --publish-all=true -p 8888 cloudera/quickstart /usr/bin/docker-quickstart
}


function download {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
wget -c -t 0 -T 20 $1
}

function jsonoverview {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
jq -f ~/bin/jsonoverview.jq "$@"
}
