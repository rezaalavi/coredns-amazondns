#!/bin/sh

VERSION=0.2.1
TAG=b1ce9ed6e5b6178fbfa73d3764d25a6e1f20fc82
CADDY_TAG=37b291f82c2083a378b698577640389686b0baf4

if [ "$1" = "" ]; then
    docker run --rm \
        -v $(pwd):/go/src/github.com/rezaalavi/coredns-amazondns \
        -v $(pwd)/.tmp:/go \
        -w /go/src/github.com/rezaalavi/coredns-amazondns \
        golang:1.9 ./build.sh $TAG $CADDY_TAG
else 
    echo "Building CoreDNS:$1 with amazondns..."

    go get github.com/coredns/coredns

    cd /go/src/github.com/mholt/caddy

    git checkout $2

    cd /go/src/github.com/coredns/coredns

    git reset --hard HEAD
    git clean -f

    git checkout $1
    if [ "$?" -ne 0 ]; then
        echo "Invalid tag: $1"
        exit 1
    fi

    sed -i -e "/^route53:route53$/i amazondns:github.com/
    
    
    
    
    
    
    
    
    
    
    
    
    
    /coredns-amazondns" plugin.cfg 

    if [ "$?" -ne 0 ]; then
        echo "Failed"
        exit 1
    fi

    cat plugin.cfg

    go generate
    #make
    go build

    cp coredns /go/src/github.com/rezaalavi/coredns-amazondns/
    tar cvzf coredns-amazondns_${VERSION}_linux-amd64.tgz coredns
    mv coredns-*.tgz /go/src/github.com/rezaalavi/coredns-amazondns/
fi

