#!/bin/sh

set -x

PATH=$HOME/.local/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:$HOME/.local/go/bin
GOPATH="$HOME/.local/go"
GOBIN="$HOME/.local/bin/go"
export GOPATH

brew update
brew upgrade
pip2 list --format columns | tail -n +3 | cut -f 1 -d " " | xargs pip2 install -U
pip3 list --format columns | tail -n +3 | cut -f 1 -d " " | xargs pip3 install -U


$GOBIN get -u github.com/maxbrunsfeld/counterfeiter
$GOBIN get -u golang.org/x/tools/cmd/go-contrib-init
$GOBIN get -u golang.org/x/review/git-codereview
$GOBIN get -u golang.org/x/tools/cmd/goimports
$GOBIN get -u github.com/ramya-rao-a/go-outline
$GOBIN get -u github.com/alecthomas/gometalinter
$GOBIN get -u github.com/nsf/gocode
$GOBIN get -u github.com/tpng/gopkgs
$GOBIN get -u github.com/acroca/go-symbols
$GOBIN get -u golang.org/x/tools/cmd/guru
$GOBIN get -u golang.org/x/tools/cmd/gorename
$GOBIN get -u github.com/fatih/gomodifytags
$GOBIN get -u github.com/josharian/impl
$GOBIN get -u github.com/rogpeppe/godef
$GOBIN get -u sourcegraph.com/sqs/goreturns
$GOBIN get -u github.com/cweill/gotests/...
$GOBIN get -u github.com/golang/dep/cmd/dep

$HOME/.local/go/bin/gometalinter --install

$GOBIN get github.com/stretchr/testify
