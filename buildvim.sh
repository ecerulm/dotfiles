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


# Make sure that you don't have pyenv running, for some reason you will get
# problems (with UltiSnips for example), everythin will compile but somehow the
# python will not be able to load the modules from the pythonx and python2 dirs

# make distclean
git clean -dfx
./configure \
  --prefix=$HOME/.local/stow/vim \
  --with-features=huge \
  --with-compiledby="RubenLaguna" \
  --enable-cscope \
  --enable-pythoninterp=yes  \
  --with-python-config-dir=/usr/lib/python2.7/config \
  --enable-fail-if-missing \
  --enable-multibyte \
  --enable-pythoninterp=yes  \
  --enable-rubyinterp \
  --enable-luainterp=yes \
  --with-lua-prefix=/usr/local \
  --enable-gui=auto
make
# make install prefix=$HOME/.local/stow/vim
make install
vim --version

