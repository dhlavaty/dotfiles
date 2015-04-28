#!/bin/bash

# Last change: 2014-08-30 13:56

readonly sourceDir="/Users/{username}/Documents/TemporaryNonBackup/iPhoto-to-NAS-autosort"       # remove trailing "/"
readonly destDir="/Volumes/Qrodinne/iPhoto-backups"

# dependencies: exiv2 (On Mac accessible through Homebrew)
# TODO: exiv2 rename -t *   -- Filename sanitation
# TODO: exiv2 fixiso        -- Copy the ISO setting from one of the proprietary Nikon or Canon makernote ISO tags to the regular Exif ISO tag
# TODO: or maybe: https://github.com/JamieMason/ImageOptim-CLI

check_if_dir_exist() {
  local dir_to_check=$1

  if [ ! -d "$dir_to_check" ]
  then
    echo -e "[ERROR] Destination directory '$dir_to_check' does not exist or it is not mounted properly"
    exit
  fi
}

find_oldest_file_in_dir() {
  local dir_to_check=$1

  # find oldest file in directory
  find "$dir_to_check" -type f -print0 \
      | xargs -0 ls -1tr \
      | head -n 1
}

### get EXIF DateTime taken of given file (we use exiv2 to do this) - return format is 2014:02:28 11:22:33
find_datetime_taken_of_picture() {
  local pic=$1

  # get EXIF DateTime taken of $pic file (we use exiv2 to do this) - format is 2014:02:28 11:22:33
  local dateTimeTaken=$(exiv2 -g Exif.Photo.DateTimeOriginal -Pv print "$pic")
  ###echo -e "Taken datetime: $dateTimeTaken"

  if [ -z "$dateTimeTaken" ]
  then
    # second try to get EXIF Date taken for this photo
    dateTimeTaken=$(exiv2 -g Exif.Image.DateTime -Pv print "$pic")
    ###echo -e "Taken datetime try2: $dateTimeTaken"
  fi

  if [ -z "$dateTimeTaken" ]
  then
    # file datetime is the last option - its format is 2014-02-25 14:36:32.100650260 +0100
    dateTimeTaken=$(stat -c %y "$pic")
    dateTimeTaken=${dateTimeTaken//-/:}  # replace '-' with ':' to match exiv2 datetime format
    ###echo -e "Taken datetime try3: $dateTimeTaken"
  fi

  echo "$dateTimeTaken"
}


main() {

  check_if_dir_exist $destDir

  local dirIterator

  # correct [for] loop so that path and filename can contain special characters like spaces
  find $sourceDir -type d -and -not -wholename $sourceDir | while read dirIterator
  do
    # $dirIterator does not contain trailing slash '/'
    echo -e "\nProcessing directory: $dirIterator"


    # Get name of directory
    local dirName=$(basename "$dirIterator")
    echo -e "Base dir name: $dirName"


    # rename jpgfiles to datetimes (using exiv2)
    pushd "$dirIterator"
    exiv2 -t -F rename *
    popd


    # find oldest file in directory
    local oldest_file=$(find_oldest_file_in_dir "$dirIterator")
    echo -e "Oldest file: $first"


    # get EXIF DateTime taken of $oldest_file file (we use exiv2 to do this) - format is 2014:02:28 11:22:33
    local dateTimeTaken=$(find_datetime_taken_of_picture "$oldest_file")
    echo -e "Taken datetime: $dateTimeTaken"


    # parse datetime to variables
    read YEAR MONTH DAY TIME <<<${dateTimeTaken//:/ }
    echo -e "Parsed datetime - year: $YEAR  month: $MONTH  day: $DAY"


    # Move source directory to a destination
    echo "Moving source dir to destination"
    # Create YEAR subdirectory if that does not exist
    mkdir -p "${destDir}/${YEAR}/"
    # Move
    mv "$dirIterator" "${destDir}/${YEAR}/${YEAR}-${MONTH}-${DAY} ${dirName}"
    echo "Moving DONE"
  done

  echo -e "\n\nScript DONE\n\n"

}
main