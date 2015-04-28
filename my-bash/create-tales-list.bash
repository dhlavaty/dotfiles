#!/bin/bash

# Last change: 2014-09-07 20:43
# move to /usr/local/bin


check_if_dir_exist() {
  local dir_to_check=$1

  if [ ! -d "$dir_to_check" ]
  then
    echo -e "[ERROR] Directory '$dir_to_check' does not exist or it is not mounted properly"
    exit
  fi
}

create_dir_listing() {
  local sourceDir=$1
  local outFile=$2

  check_if_dir_exist $sourceDir

  pushd "$sourceDir"
  find . -type f | LC_ALL=C sort -f -o "$outFile"
  popd
}

main() {


  local sourceDir="/Volumes/Qmultimedia/rozpravky/"
  local outFile="/Users/dhlavaty/Dropbox/Public/rozpravky.txt"

  create_dir_listing "$sourceDir" "$outFile"


  sourceDir="/Volumes/Qmultimedia/serialy/"
  outFile="/Users/dhlavaty/Dropbox/Public/serialy.txt"

  create_dir_listing "$sourceDir" "$outFile"



  echo -e "\n\nScript DONE\n\n"

}
main