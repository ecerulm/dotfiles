# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi


export NVM_DIR="$HOME/.nvm"
if [ -d "$(brew --prefix  nvm)" ]; then
  NVM_INSTALL_DIR=$(brew --prefix nvm)
  [ -s "$NVM_INSTALL_DIR/nvm.sh" ] && \. "$NVM_INSTALL_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_INSTALL_DIR/etc/bash_completion.d/nvm" ] && \. "$NVM_INSTALL_DIR/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

function debug() {
  [ -n "$debug" ] && echo " debug: $@"
}

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# _bash_history_append() {
#     builtin history -a # append current history to the file ~/.bash_history
#     builtin history -c #  clears the history for the current shell, and does not delete ~/.bash_history.
#     builtin history -r # rereds the history from ~/.bash_history
# }
# PROMPT_COMMAND="_bash_history_append; $PROMPT_COMMAND"
# The problem with the above is that you will lose the local history per shell, so if you go to previous command in one shell you can get a command that was typed in another shell

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
alias cssh="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

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

alias codepoints='perl -C7 -ne '"'"'for(split(//)){print sprintf("U+%04X", ord) . " " . $_ . "\n"}'"'"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if ! shopt -oq posix; then
#   if [ -f /usr/share/bash-completion/bash_completion ]; then
#     . /usr/share/bash-completion/bash_completion
#   elif [ -f /etc/bash_completion ]; then
#     . /etc/bash_completion
#   fi
# fi

# Go / Golang
export GOPATH="$HOME/go"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

for BINDIR in $HOME/.local/bin $HOME/.local/sbin; do
  if [ -d "$BINDIR" ]; then
    export PATH="$BINDIR:$PATH"
  fi
done

export PATH="$GOPATH/bin:$PATH"

export EDITOR=nvim
alias vi=nvim
alias vim=nvim
# alias tmux="tmux -2"
alias pyenvreq='sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils '
alias pyenvreqosx='brew install xz readline openssl' # https://github.com/yyuu/pyenv/wiki/Common-build-problems
alias pyenvinstall="git clone https://github.com/yyuu/pyenv.git ~/.pyenv && git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv"
alias pyenvupdate="cd ~/.pyenv && git pull && cd plugins/pyenv-virtualenv && git pull"
alias pyenvinstall27="env CONFIGURE_OPTS='--enable-shared' pyenv install 2.7.12"
alias pyenvinstall27osx="pyenv install 2.7.17"
alias pyenvinstall35="env CONFIGURE_OPTS='--enable-shared' pyenv install 3.5.2"
alias pyenvinstall36="installpythonprereq; env CONFIGURE_OPTS='--enable-shared' pyenv install 3.6.2"
alias pyenvansible="pyenv virtualenv 2.7.12 venv-ansible; pyenv shell venv-ansible && pip install ansible"
# alias ansible="~/.pyenv/versions/venv-ansible/bin/ansible"
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
alias gca="git commit -v --amend"
alias gau="git a" # git add -u
alias gap="git a -p"
alias glc="git rev-parse HEAD"
alias gdm="git diff master"
alias gdms="git diff --stat master"
alias gdlc="git diff HEAD^ HEAD" # or git diff @~..@ 
alias gfa="git fetch --all"
alias gb="git branch --sort=-committerdate"
alias garchive="git archive --format zip  -o archive.zip HEAD"
alias packages2install="curl -k https://gist.githubusercontent.com/ecerulm/be59ec62ad77178d61a5/raw | sh"
alias pipenv=/usr/local/bin/pipenv
alias nvr=/Users/rublag/.pyenv/versions/venv-py36-neovim/bin/nvr
alias rsync='rsync -azvcC'
alias whatsmyip='curl -s https://checkip.amazonaws.com'
alias checkip='curl -s https://checkip.amazonaws.com'

function gl {
  git l
}

function gdca {
  # Diff branch head from the branching point (common ancestor of branch and master)
  # Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
  CID=${1:-HEAD}
  git diff $(git merge-base "$CID" master) "$CID"
}

function gdiffbranches {
  if [ "$#" -ne 2 ]; then
    echo "Usage: gdiffbranches branchname otherbranchname(origin/main,master,etc)"
    return 1
  fi
  #git diff --name-only "$1" $(git merge-base "$2" "$1")
  git diff --stat $(git merge-base "$2" "$1") "$1" 
}

function gbranches {
  # Credit http://stackoverflow.com/a/2514279
  for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r
}

function rtags {
  Rscript -e 'rtags(path="./", recursive=TRUE, ofile="RTAGS")' -e 'etags2ctags("RTAGS", "rtags")' -e 'unlink("RTAGS")'
}

function dotfiles {
  cd ~/dotfiles
  s
  open https://github.com/ecerulm/dotfiles
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

function installjupyter27() {
  pyenv virtualenv 2.7.12 venv-jupyter27
  echo "install jupyter on venv-jupyter27 and some useful modules"
  pyenv shell venv-jupyter27
  pip install -U pip
  pip install jupyter numpy scikit-learn matplotlib pandas scipy seaborn ipykernel
  pip2 install ipykernel
  python2 -m ipykernel install --user # kernelspec installed at Users/rl186056/Library/Jupyter/kernels/python2/kernel.json
}

function installjupyter36() {
  # install python 3.6.2 first with pyenv install 3.6.2
  pyenv virtualenv 3.6.2 venv-jupyter36
  pyenv shell venv-jupyter36
  pip3 install -U pip
  pip3 install jupyter numpy scikit-learn matplotlib pandas scipy seaborn ipykernel statsmodels

  # Deep Learning packages from https://github.com/the-deep-learners/TensorFlow-LiveLessons/blob/791d14280f53d4c340391c8990f86ceea9ae4303/Dockerfile
  pip3 install tensorflow==1.0.0 tflearn==0.3.2 keras==2.0.8 nltk==3.2.4 gensim==2.3.0 gym==0.9.4
  pip3 install pydot
  python3 -m pip install ipykernel
  python3 -m ipykernel install --user # kernelpec installed at /Users/rl186056/Library/Jupyter/kernels/python3/kernel.json
}

function installjupyterlab() {
  pyenv virtualenv 3.6.2 venv-jupyterlab
  pyenv shell venv-jupyterlab
  pip install -U pip
  pip3 install -U jupyter jupyterlab jupyterlab-launcher numpy scikit-learn matplotlib pandas scipy seaborn ipykernel statsmodels
  pip3 install tensorflow==1.0.0 tflearn==0.3.2 keras==2.0.8 nltk==3.2.4 gensim==2.3.0 gym==0.9.4
  pip3 install -U pydot
  pip3 install -U h5py
  python -m pip install ipykernel
  # python -m ipykernel install --user # kernelpec installed at /Users/rl186056/Library/Jupyter/kernels/python3/kernel.json
}

function installjupyter() {
  installjupyter27
  installjupyter36
  installjupyterlab

  # install 2.7 kernel on the Py3 jupyter
  # $(pyenv prefix venv-jupyter27)/bin/python -m ipykernel install --prefix=$(pyenv prefix venv-jupyter36) --name 'Python-2-venv-jupyter27'
  # install 3.6 kernel on the Py2 jupyter
  # $(pyenv prefix venv-jupyter36)/bin/python -m ipykernel install --prefix=$(pyenv prefix venv-jupyter27) --name 'Python-3-venv-jupyter36'
}

jupyternotebookserver36() {
pyenv shell venv-jupyter36
#cd ~/Dropbox/JupyterNotebooks/
cd ~
jupyter-notebook
}

function jupyterlabserver() {
  pyenv shell venv-jupyterlab
  cd ~
  # jupyter notebook --version

  # https://github.com/jupyterlab/jupyterlab/issues/2980
  jupyter lab --NotebookApp.notebook_dir=$HOME
}

function pipinstallds() {
  pip install matplotlib numpy scikit-learn pandas seaborn 
  pip install scipy
}

function installmaven {
  curl -O http://apache.mirrors.spacedump.net/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz
  tar xvzf apache-maven-3.5.0-bin.tar.gz
  mv apache-maven-3.5.0 $HOME/.local/stow/
}

function installjupyterlabextensions {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
  pyenv shell venv-jupyterlab

  # table of contents plugin
  jupyter labextension install jupyterlab-toc

}

function sparkshell {
  echo "Run sdk use spark 2.4.0 # SDKman"
  $SPARK_HOME/bin/spark-shell --master local[2]
}

function getsecret {
 aws secretsmanager get-secret-value --secret-id "$@"
}



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

# See also .bashrc.thismachine (equivalent to .bashrc.local)


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

for HIVE_HOME in "$HOME/.local/stow/apache-hive-2.3.0-bin"  "$HOME/.local/stow/apache-hive-1.1.0-bin"; do
  debug "Checking for HIVE_HOME=${HIVE_HOME}"
  if [ -d "$HIVE_HOME" ]; then
    debug "Setting  HIVE_HOME=${HIVE_HOME}"
    export HIVE_HOME
    export PATH="$HIVE_HOME/bin:$PATH"
    break
  fi
done


for MAVEN_HOME in "$HOME/.local/stow/apache-maven-3.5.0"; do
  debug "Checking for MAVEN_HOME=${MAVEN_HOME}"
  if [ -d "$MAVEN_HOME" ]; then
    debug "Setting  MAVEN_HOME=${MAVEN_HOME}"
    export MAVEN_HOME
    export PATH="$MAVEN_HOME/bin:$PATH"
    break
  fi
done



# If you are using sdkman to install spark this will have no effect
# since sdkman loads after 
SPARK_HOME_CANDIDATES=(
"$HOME/.local/stow/spark-2.2.0-bin-hadoop2.7/"
"$HOME/spark-2.3.1-bin-hadoop2.7/"
)

for SPARK_HOME in "${SPARK_HOME_CANDIDATES[@]}"; do
  debug "Checking for SPARK_HOME=${SPARK_HOME}"
  if [ -d "$SPARK_HOME" ]; then
    debug "Setting  SPARK_HOME=${SPARK_HOME}"
    export SPARK_HOME
    export PATH="$SPARK_HOME/bin:$PATH"
    break
  fi
done

for NIFI_HOME in "$HOME/.local/stow/nifi-1.0.0"; do
  debug "Checking for NIFI_HOME=${NIFI_HOME}"
  if [ -d "$NIFI_HOME" ]; then
    debug "Setting  NIFI_HOME=${NIFI_HOME}"
    export NIFI_HOME
    export PATH="$NIFI_HOME/bin:$PATH"
    break
  fi
done

for ES_HOME in "$HOME/.local/stow/elasticsearch-5.5.2"; do
  debug "Checking for ES_HOME=${ES_HOME}"
  if [ -d "$ES_HOME" ]; then
    debug "Setting  ES_HOME=${ES_HOME}"
    export ES_HOME
    export PATH="$ES_HOME/bin:$PATH"
    break
  fi
done


for KIBANA_HOME in "$HOME/.local/stow/kibana-5.5.2-darwin-x86_64" "$HOME/.local/stow/kibana-5.5.2-linux-x86_64" ; do
  debug "Checking for KIBANA_HOME=${KIBANA_HOME}"
  if [ -d "$KIBANA_HOME" ]; then
    debug "Setting  KIBANA_HOME=${KIBANA_HOME}"
    export KIBANA_HOME
    export PATH="$KIBANA_HOME/bin:$PATH"
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

function createjavaservercert {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
KEYPASS=changeit
STOREPASS=changeit

echo "Generate server certificate and export it"
${JAVA_HOME}/bin/keytool -genkey -alias server-alias -keyalg RSA -keypass $KEYPASS -storepass $STOREPASS -keystore keystore.jks
${JAVA_HOME}/bin/keytool -export -alias server-alias -storepass $STOREPASS -file server.cer -keystore keystore.jks

echo "Create trust store"
${JAVA_HOME}/bin/keytool -import -v -trustcacerts -alias server-alias -file server.cer -keystore cacerts.jks -keypass $KEYPASS -storepass $STOREPASS
}


function installnifi {
wget -c https://archive.apache.org/dist/nifi/1.0.0/nifi-1.0.0-bin.tar.gz
tar xvzf nifi-1.0.0-bin.tar.gz
mv nifi-1.0.0 ~/.local/stow/
}


function installelasticsearch {
FILENAME="elasticsearch-5.5.2.tar.gz"
  wget -c "https://artifacts.elastic.co/downloads/elasticsearch/$FILENAME"
  cat "$FILENAME" | (cd ~/.local/stow && tar xzf -)
}

function installneovimdependencies {
  # nvim
  # pushd .
  # cd ~/.pyenv
  # git pull
  # popd

  pyenv install -s 2.7.17 # skip if existing
  pyenv virtualenv 2.7.17 venv-py27-neovim
  pyenv activate venv-py27-neovim
  pip2 install neovim websocket-client sexpdata
  pyenv deactivate

  pyenv install -s 3.8.2 # skip if existing
  pyenv virtualenv 3.8.2 venv-py36-neovim
  pyenv activate venv-py36-neovim
  pip3 install neovim websocket-client sexpdata
  pyenv deactivate
}

function elasticsearchstats {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
curl -s -XGET 'http://localhost:9200/*/_stats/docs,store' | jq '.indices'
}

function scalarepl {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
coursier launch com.lihaoyi:ammonite_2.11.8:0.7.0
}

function beeline {
  $HIVE_HOME/bin/beeline "$@"
}

function awslistcloudfront {
  pyenv activate venv-blog # pyenv virtualenv 3.6.2 venv-blog; pyenv shell venv-blog; pip install awscli
  aws cloudfront list-distributions --query 'DistributionList.Items[].{id:Id,comment:Comment,domain:DomainName}'
  pyenv deactivate
}

function awslistcertificates {
  pyenv activate venv-blog # pyenv virtualenv 3.6.2 venv-blog; pyenv shell venv-blog; pip install awscli
  aws acm list-certificates --certificate-statuses ISSUED
  pyenv deactivate
}

function eslistindexes {
  # to get the list of indices
  curl -XGET "localhost:${ES_PORT:-9200}/_cat/indices?v&pretty"
}

function mvnquickjavaproject {
  quickjavaproject "$@"
}

function quickjavaproject {
   echo "Usage: quickjavaproject artifactId groupid "
   mvn archetype:generate -DgroupId=${2:-com.rubenlaguna} -DartifactId=${1:-my-app} -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
}

function mvnnotest {
  echo "this will NOT compile the tests. If you want to compile the test but skip running them use -DskipTests=true instead."
  mvn -Dmaven.test.skip=true "$@"
}

function mvndelete {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
echo "Usage mvndelete groupId:artiFactId:version"
mvn dependency:purge-local-repository -DreResolve=false -DmanualInclude="$1"
}

function mvndeploy {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
# this will add the file to the current directory /repo
# Usage mvndeploy myfile.jar com.example myArtifact 1.0
mvn deploy:deploy-file -Durl=file://$PWD/repo/ -Dfile=$1 -DgroupId=$2 -DartifactId=$3 -Dpackaging=jar -Dversion=$4
}

function mvnnbm {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
# to bu run in the application/ directory of  a Netbeans RCP application
mvn nbm:cluster-app nbm:run-platform
}

function mci {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
 echo "mvn clean install"
 mvn clean install
}

function newhaskellapp {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
stack new hello-world simple --resolver=lts-7.8

}

function hiveconf {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
vim $HIVE_HOME/conf/{hive-site.xml,hive-env.sh,hive-exec-log4j.properties,hive-log4j.properties}
}

function hadoopconf {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
vim $HADOOP_CONF_DIR/{hadoop-env.sh,mapred-site.xml,core-site.xml,hdfs-site.xml,yarn-site.xml}
}

function sshportforwarding {
  echo "Run command: ssh -f -N -L<localport>:<remotehost>:<remoteport> username@hostname"
  echo "The localhost is binded to your local address in your laptop"
  echo "the connection to remotehost:remoteport is initiated at the ssh remote side username@hostname, so the remotehost can be a DNS name that only exists at that side"
}

function awslistinstance {
  aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*]'
  # echo "git-bucket " `aws ec2 describe-instances --instance-id $AISIN_AWS_GITBUCKET_INSTANCEID  --profile dev-aisin --output text --query 'Reservations[*].Instances[*].[State.Name,PrivateIpAddress]'`
}

function awslistinstancenames {
  # Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
  aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].Tags[?Key==`Name`].Value'
}

function awsfindautoscalinggroupofinstance {
  # Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
  aws autoscaling describe-auto-scaling-instances --instance-ids "$@"

}
function mavenalljars {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
  mvn dependency:build-classpath -DincludeScope=compile -Dmdep.outputFilterFile=true|grep 'classpath='|cut -f 2 -d '=' | tr ":" "\n"
}

function mavendependencytree {
  mvn dependency:tree -Ddetail=true
}

function mavencoverage {
  mvn clean clover:setup test clover:aggregate clover:clover
  open target/site/clover/dashboard.html
}

function mvncoverage {
  mavencoverage
}

function mvnalljars {
  mavenalljars
}

function dockerjenkins {
# Access parameters $1, $2, ${$1:mydefaultvalue}	"$@"
echo "To get latest version of docker run:"
echo "docker pull jenkins/jenkins:lts"
echo "https://github.com/jenkinsci/docker/blob/master/README.md"
docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
}

function bashrc() {
  vim ~/.bashrc
  source ~/.bashrc
}

function httpserver() {
  
  python3.9 -m http.server 8080
}

function scalareplgradle {
  # This requires that your  gradle project has a printClasspath task 
  # https://chris-martin.org/2015/gradle-scala-repl
  java -Dscala.usejavacp=true -classpath "$(gradle printClasspath --quiet)" scala.tools.nsc.MainGenericRunner
}

function printcert {
  openssl x509 -in $1 -text -noout
  # openssl x509 -inform pem -in $1 -noout -text # read it as PEM
  # openssl x509 -inform der -in $1 -noout -text # read it as CER
}

function printcertpem {
   openssl x509 -inform pem -in $1 -noout -text # read it as PEM
}

function printcertder {
   openssl x509 -inform der -in $1 -noout -text # read it as DER
}

function airflowprecommitbranch {
  pyenv shell airflow-venv
  git fetch origin
  time pre-commit run --from-ref $(git merge-base origin/main HEAD)  --to-ref HEAD
}

function airflowcoretests {
  cd ~/git/airflow
  pyenv shell airflow-venv
  ./breeze --backend mysql --db-reset --test-type Core tests 
}

function airflowalltests {
  cd ~/git/airflow
  pyenv shell airflow-venv
  ./breeze --backend mysql --db-reset --test-type All tests 
}

function airflowstaticcheck {
# https://github.com/apache/airflow/blob/main/STATIC_CODE_CHECKS.rst
  cd ~/git/airflow
  pyenv shell airflow-venv
  git fetch origin
  ./breeze static-check all -- --from-ref $(git merge-base origin/main HEAD) --to-ref HEAD
 
}

# Don't ever put .bashrc.thismachine in git 
# .bashrc.local
# it contains SENSITIVE information
if [ -f ~/.bashrc.thismachine ]; then
  . ~/.bashrc.thismachine
fi


if [ -d "$HOME/.sdkman" ]; then
  #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# if command -v pyenv >/dev/null; then eval "$(pyenv init -)"; fi

alias pipenv=/usr/local/bin/pipenv
export PIPENV_IGNORE_VIRTUALENVS=1 

export GPG_TTY=$(tty)

export LANG="en_US.UTF-8"

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then 
  if [ -n "$(command -v nvr)" ]; then
    alias nvim=nvr
  else
    alias nvim='echo "No nesting!"'
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash


export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

[ -d $HOME/.local/bin ] && export PATH=$PATH:$HOME/.local/bin



shellpodns() {
   kubectl run --namespace "$1" --generator=run-pod/v1 -ti --rm test-$RANDOM --image-pull-policy Always --image=ecerulm/ubuntu-tools:latest
}

[ -f "/Users/ecerulm/.ghcup/env" ] && source "/Users/ecerulm/.ghcup/env" # ghcup-env

[ -f $HOME/.bash_completion.d/breeze-complete ] && source $HOME/.bash_completion.d/breeze-complete
# START: Added by Airflow Breeze autocomplete setup
for bcfile in ~/.bash_completion.d/* ; do
    . ${bcfile}
done
# END: Added by Airflow Breeze autocomplete setup

shortname() {
  ldapsearch -LLL "(displayName=$*)" sAMAccountName 2>&1| grep sAMAccountName
}

ldaplookup() {
  ldapsearch -Q -LLL "displayName=$*" sAMAccountName userPrincipalName mail |grep -E "^\w+: "
}

randompassword() {
  cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9$./,:' | fold -w 32| head -n 1
}

function colors() {
  # echo -ne "\u001b[0m\u001b[40m" # 8-color palette: black background
  # for  i in {0..255}; do printf "\x1b[38;5;${i}m${i} "; done
  # echo ""
  # echo -ne "\u001b[0m\u001b[47m" # 8-color palette: white background
  # for  i in {0..255}; do printf "\x1b[38;5;${i}m${i} "; done
  # echo ""
  for i in {0..255}; do
    # echo -ne "\u001b[48;5;${i}m   \u001b[0m \u001b[38;5;${i}m ${i}\u001b[0m "
    printf "\u001b[48;5;${i}m   \u001b[0m \u001b[38;5;${i}m %3d\u001b[0m " "$i"
    if [[ (( $i > 0)) && $(( $i % 16 )) = 0 ]]; then
      echo -e "" 
    fi
    # echo -ne "\u001b[38;5;${i}m ${i} \u001b[0m"
  done
  echo -e ""
}


function ide() {
  if [[ -z "$TMUX_PANE" ]]; then
    echo "You must run this inside tmux"
    return
  fi
  tmux select-pane -T 'NeoVim'
  tmux split-window -v -l 20%
  tmux select-pane -T "Build tasks" # works because the new pane is the active pane
  export SHELL_TMUX_PANE=$(tmux split-window -h -P -F "#{pane_id}")
  tmux select-pane -T "Other commands" # works because the new pane is the active pane
  tmux select-pane -t "$TMUX_PANE" # give focus to the pane that invoked with script
}

function ide2() {
  if [[ -z "$TMUX_PANE" ]]; then
    echo "You must run this inside tmux"
    return
  fi
  tmux select-pane -T 'NeoVim' # change pane title
  export SHELL_TMUX_PANE=$(tmux split-window -v -l 20% -P -F "#{pane_id}") # create new horizontal split
  tmux select-pane -T "shell commands" # works because the new pane is the active pane
  tmux select-pane -t "$TMUX_PANE" # give focus to the pane that invoked with script
}

function ideterraform() {
  if [[ -z "$TMUX_PANE" ]]; then
    echo "You must run this inside tmux"
    return
  fi
  tmux select-pane -T 'NeoVim' # change pane title
  export SHELL_TMUX_PANE=$(tmux split-window -h -l 20% -P -F "#{pane_id}") # create new horizontal split
  # 
  tmux select-pane -T "shell commands" # works because the new pane is the active pane
  tmux select-pane -t "$TMUX_PANE" # give focus to the pane that invoked with script
}

function nvimconfig() {
  cd ~/.config/nvim || exit
  vim ~/.config/nvim
}

export PATH="$(brew --prefix make)/libexec/gnubin/:$PATH"

export KREW_ROOT="${KREW_ROOT:-$HOME/.krew}"

if [[ -d "${KREW_ROOT}/bin" ]]; then
  export PATH="${KREW_ROOT}/bin:$PATH"
fi

function pyactivate() {
  if [ "$#" -ne 1 ]; then
      echo "Usage: pyactivate <nameofvirtualenv>"
      echo "pyenv versions # list virtualenvs"
      return
  fi
  PREFIX=$(pyenv prefix $1)
  if [ $? -ne 0 ]; then
    echo "that pyenv version does not exist"
    return
  fi
  ACTIVATESCRIPT=${PREFIX}/bin/activate
  if [[ ! -e "$ACTIVATESCRIPT" ]]; then
    _OLD_VIRTUAL_PATH="${PATH}"
    PATH="${PREFIX}/bin:${PATH}"
    function deactivate() {
      PATH="${_OLD_VIRTUAL_PATH}"
      unset -f deactivate
    }
    # echo "There is not activate script at ${ACTIVATESCRIPT}"
    return
  else
    source "${ACTIVATESCRIPT}"
  fi
}

export PATH="~/.local/bin:$PATH"
