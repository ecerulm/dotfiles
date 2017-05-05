#!/bin/bash
set -euxo pipefail
# e : fail as soon as a command fails, don't continue
# u : fail if nonexisting variable can't be expanded
# x : echo each line as it's executed
# -o pipefail: fail if a command in a pipe returns status != 0

# git clone https://github.com/vim/vim
# cd vim
# copy buildvim.sh
# ./buildvim.sh
# --with-python-config-dir=/Users/ecerulm/.pyenv/versions/2.7.12/lib/python2.7/config \
#  --enable-rubyinterp \
#  --enable-luainterp \


make distclean
git clean -dfx
./configure \
  --prefix=$HOME/.local/ \
  --with-features=huge \
  --with-compiledby="RubenLaguna" \
  --enable-cscope \
  --enable-pythoninterp=yes  \
  --with-python-config-dir=/Users/ecerulm/.pyenv/versions/2.7.12/lib/python2.7/config \
  --enable-fail-if-missing \
  --enable-multibyte \
  --enable-pythoninterp=yes  \
  --enable-gui=auto 
make
make install prefix=$HOME/.local/stow/vim
vim --version

