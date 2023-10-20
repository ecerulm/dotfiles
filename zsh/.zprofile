# This is source only for login shells 
# This file is sourced before .zshrc
#
export PATH=$HOME/.jbang/bin:$PATH 
export PATH="/usr/local/opt/openjdk@17/bin:$PATH"

function awsprofile {
  export AWS_PROFILE=$(aws configure list-profiles|fzf)
}

function switchbranch {
  git switch $(git branch | fzf)
}
