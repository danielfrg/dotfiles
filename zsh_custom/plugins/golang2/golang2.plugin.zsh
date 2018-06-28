local tools_dir=~/workspace/go
# export PATH=$tools_dir/bin:$PATH

export GOPATH=~/workspace/go
export PATH=$GOPATH/bin:$PATH

gopathhere() {
    export GOPATH=$(pwd)
    export PATH=$GOPATH/bin:$PATH
    export GOBIN=$(pwd)/bin
    echo GOPATH=$GOPATH
    echo PATH=$PATH
    echo GOBIN=$GOBIN
}

goinstalltools() {
    local old_path=$PATH
    local old_go_path=$GOPATH
    export GOPATH=$tools_dir
    go get -v -u golang.org/x/lint/golint
    go get -v -u github.com/derekparker/delve/cmd/dlv
    go get -v -u github.com/uudashr/gopkgs/cmd/gopkgs
    go get -v -u github.com/nsf/gocode
    go get -v -u github.com/rogpeppe/godef
    go get -v -u golang.org/x/tools/cmd/goimports
    go get -v -u github.com/ramya-rao-a/go-outline
    export PATH=$old_path
    export GOPATH=$old_go_path
}
