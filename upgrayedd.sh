#!/bin/sh

set -x

PATH=$HOME/.local/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:$HOME/.local/go/bin

mas upgrade
brew update
brew upgrade
python -m pip list --format columns | tail -n +3 | cut -f 1 -d " " | xargs python -m pip install -U

$HOME/.cargo/bin/rustup update

$HOME/.local/bin/goupgrades.sh
