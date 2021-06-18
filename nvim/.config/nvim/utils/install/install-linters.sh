#!/bin/bash

function lint_lua() {
	npm install -g lua-fmt

}

function main() {
	lint_lua
}

main
