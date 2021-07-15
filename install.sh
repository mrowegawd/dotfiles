#!/bin/bash

git submodule init
git submodule update

PWD=$(pwd)

copyhome() {
  cd home
  rsync -avz . ~
}

stowit() {
  usr=$1
  app=$2
  # -v verbose
  # -R recursive
  # -t target
  stow -v -R -t "${usr}" "${app}"
}

main() {
  copyhome
  cd $PWD

  for filename in *; do

    if [[ -d $filename ]]; then

      if [[ $filename == "home" ]]; then
        continue
      fi

      if [[ $filename == "img" ]]; then
        continue
      fi

      stowit "$HOME" "$filename"
    fi
  done

}

main

echo ""
echo "##### ALL DONE"
