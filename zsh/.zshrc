# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/dotfiles/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
path+=(/opt/homebrew/bin)

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
path+=(/opt/homebrew/bin)
plugins=(macos direnv)


# HISTFILE="$HOME/.zsh_history" # the default is set on /etc/zshrc
HISTSIZE=10000000
SAVEHIST=10000000
setopt appendhistory



# HISTORY_IGNORE="(#i)(ls*|pwd*|*password*|s *)"

# zshaddhistory() {
#   emulate -L zsh
#   setopt LOCAL_OPTIONS
#   setopt EXTENDED_GLOB
#   unsetopt CASE_MATCH
#   COMMAND=${1[1,-2]}
#   PATTERN='^(ls|pwd|s|.*password.*)$'
#   # ! [[ ${COMMAND} =~ ${PATTERN} ]] && echo "$COMMAND will be added to history" || echo "$COMMAND will not be added to history"
#   ! [[ ${COMMAND} =~ ${PATTERN} ]]

# }
source $ZSH/oh-my-zsh.sh

setopt APPEND_HISTORY
unsetopt INC_APPEND_HISTORY
unsetopt INC_APPEND_HISTORY_TIME
unsetopt SHARE_HISTORY

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="nvim $ZDOTDIR/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/dotfiles/zsh/.p10k.zsh.
[[ ! -f ~/dotfiles/zsh/.p10k.zsh ]] || source ~/dotfiles/zsh/.p10k.zsh



alias vi=nvim
alias vim=nvim

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
alias gdw="git diff"
alias gfa="git fetch --all"
alias gb="git branch --sort=-committerdate"

alias l="eza -l -s mod"
alias t="eza -l -s mod -T --git-ignore"
alias reuse-annotate="pipx run reuse annotate --year 2023 --copyright 'Ruben Laguna <ruben.laguna@gmail.com>' --license GPL-3.0-or-later"
alias imgcat="kitty +kitten icat"
alias icat="kitty +kitten icat"
alias tp="terraform plan -out latest.tfplan"
alias ta="terraform apply latest.tfplan"

autoload -Uz pyactivate
autoload -Uz hello
autoload -Uz testterminal
autoload -Uz dnsflush
autoload -Uz openports
autoload -Uz pyclean
autoload -Uz randompassword

[ -x /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)
[ -x /usr/local/bin/brew ] && eval $(/usr/local/bin/brew shellenv)

# NVM node version manager
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

alias randompassword="LC_ALL=C tr -cd '[:alnum:]' < /dev/urandom | fold -w30 |head -n1"

if builtin command -v eza >/dev/null ;then
  alias ls="eza -l --git --icons --time-style long-iso -snew"
fi

# if builtin command -v bat >/dev/null ;then
#   alias cat=bat
# fi

if builtin command -v zoxide >/dev/null ;then
  eval "$(zoxide init zsh)"
  alias cd=z
fi

FZF_KEYBINDINGFILE=$(brew --prefix fzf)/shell/key-bindings.zsh
[ -e $FZF_KEYBINDINGFILE   ] && eval source $FZF_KEYBINDINGFILE
unset FZF_KEYBINDINGFILE

FZF_COMPLETIONFILE=$(brew --prefix fzf)/shell/completion.zsh
[ -e $FZF_COMPLETIONFILE ] && eval source $FZF_COMPLETIONFILE
unset FZF_COMPLETIONFILE


if builtin command -v fuck >/dev/null ;then
 eval $(thefuck --alias)
fi

[[ ! -f ~/.zshrc.thismachine ]] || source ~/.zshrc.thismachine

[[ ! -f ~/.pyenv/bin/pyenv ]] || path+=~/.pyenv/bin
# [[ ! -f ~/.pyenv/bin/pyenv ]] || eval "$(pyenv init -)"
# [[ ! -f ~/.pyenv/bin/pyenv ]] || eval "$(pyenv virtualenv-init -)"
export GPG_TTY=$TTY

path+=(~/go/bin)
# path=("$HOME/.local/bin" $path) # put ~/.local/bin at the beginning
path=(~/.local/bin $path) # put ~/.local/bin at the beginning
# path+=~/.local/bin # this puts ~/.local/bin the last 
path+=/usr/local/bin # add it to the end
# path+=$HOME/Library/Application\ Support/Coursier/bin/
path+=~/Library/Application\ Support/Coursier/bin
export PATH

alias ctags="ctags -R --fields=+zK"
export LC_ALL="en_US.utf-8"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


# The next line updates PATH for the Google Cloud SDK. gcloud
if [ -f "$HOME/.local/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/google-cloud-sdk/completion.zsh.inc"; fi
