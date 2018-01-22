#!/usr/bin/env bash
set -e
cd /go
go get -u github.com/derekparker/delve/cmd/dlv
go get -u github.com/golang/dep/cmd/dep
exec "$@"
