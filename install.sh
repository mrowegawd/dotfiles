#!/bin/bash

git submodule init
git submodule update

# PWD=$(pwd)

stowit() {
  usr=$1
  app=$2
  # -v verbose
  # -R recursive
  # -t target
  stow --adopt -vSt "${usr}" "${app}"
}

main() {

  if [[ ! -L ~/.bashrc ]]; then
    cp ./home/.bashrc ~
    cp ./home/.profile ~
  fi

  for filename in *; do

    if [[ -d "$filename" ]]; then

      if [[ $filename == "img" ]]; then
        continue
      fi

      stowit ~ "$filename"
    fi
  done

}

echo ""

main

echo "##### ALL DONE"
