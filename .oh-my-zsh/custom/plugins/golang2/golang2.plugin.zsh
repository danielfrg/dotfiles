local tools_dir=~/workspace/go-tools
export PATH=$tools_dir/bin:$PATH

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

gotoolsinstall() {
    local old_path=$PATH
    local old_go_path=$GOPATH
    export GOPATH=$tools_dir
    go get -u github.com/golang/dep/... 
    go get -u -v github.com/nsf/gocode
    go get -u -v github.com/rogpeppe/godef
    go get -u -v github.com/zmb3/gogetdoc
    go get -u -v github.com/golang/lint/golint
    go get -u -v github.com/lukehoban/go-outline
    go get -u -v sourcegraph.com/sqs/goreturns
    go get -u -v golang.org/x/tools/cmd/gorename
    go get -u -v github.com/tpng/gopkgs
    go get -u -v github.com/acroca/go-symbols
    go get -u -v golang.org/x/tools/cmd/guru
    go get -u -v github.com/cweill/gotests/...
    go get -u -v golang.org/x/tools/cmd/godoc
    go get -u -v github.com/fatih/gomodifytags
    go get -u github.com/kisielk/errcheck
    go get golang.org/x/tools/cmd/goimports
    go get github.com/tsliwowicz/go-wrk  
    go get github.com/uber/go-torch
    export PATH=$old_path   
    export GOPATH=$old_go_path   
}
