#!/bin/sh

# everything happens in ~/.profile
if [ -f "$HOME/.profile" ]
then
    . "$HOME/.profile"
fi
