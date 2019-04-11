#!/bin/sh

set -x

PATH=$HOME/.local/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:$HOME/.local/go/bin

mas upgrade
brew update
brew upgrade
pip2 list --format columns | tail -n +3 | cut -f 1 -d " " | xargs pip2 install -U
pip3 list --format columns | tail -n +3 | cut -f 1 -d " " | xargs pip3 install -U

$HOME/.cargo/bin/rustup update

$HOME/.local/bin/goupgrades.sh
