#!/bin/sh

set -e

run_tests () {
    DARKLUA_CONFIG=$1

    if [ ! -d node_modules ]; then
        yarn install
    fi
    if [ ! -d node_modules/.luau-aliases ]; then
        yarn prepare
    fi

    rm -rf temp

    rojo sourcemap test-place.project.json -o sourcemap.json

    darklua process --config $DARKLUA_CONFIG node_modules temp/node_modules
    darklua process --config $DARKLUA_CONFIG scripts/roblox-test.server.lua temp/scripts/roblox-test.server.lua

    cp test-place.project.json temp/

    rojo build temp/test-place.project.json -o temp/test-place.rbxl

    run-in-roblox --place temp/test-place.rbxl --script temp/scripts/roblox-test.server.lua
}

echo "Run test DEV=false"
run_tests .darklua-tests.json

echo "Run test DEV=true"
run_tests .darklua-tests-dev.json
