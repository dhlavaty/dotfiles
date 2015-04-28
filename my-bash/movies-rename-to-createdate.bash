#!/bin/bash

# Last change: 2014-08-30 17:22
# move to /usr/local/bin

readonly sourceDir="/Users/{username}/Documents/TemporaryNonBackup/iPhoto-to-NAS-autosort"       # remove trailing "/"
# readonly destDir="/Volumes/Qrodinne/iPhoto-backups"

# dependencies: exiv2 (On Mac accessible through Homebrew)
# TODO: exiv2 rename -t *   -- Filename sanitation
# TODO: exiv2 fixiso        -- Copy the ISO setting from one of the proprietary Nikon or Canon makernote ISO tags to the regular Exif ISO tag
# TODO: or maybe: https://github.com/JamieMason/ImageOptim-CLI

check_if_dir_exist() {
  local dir_to_check=$1

  if [ ! -d "$dir_to_check" ]
  then
    echo -e "[ERROR] Directory '$dir_to_check' does not exist or it is not mounted properly"
    exit
  fi
}

### get DateTime taken of given file (we use exiftool to do this) - return format is "CreateDate:2014:07:19:13:08:58"
find_datetime_taken_of_movie() {
  local movie=$1

  local info=$(exiftool -CreateDate -S "$movie")
    # replace ' ' with ':', and '::' with ':'
    info=${info// /:}
    info=${info//::/:}
    info=${info//+/:}
    # echo -e "Info: $info"
    # $info is now in format "CreateDate:2014:07:19:13:08:58"

    echo "$info"
}

### get DateTime taken of given file (we use exiftool to do this) - return format is "CreateDate:2014:07:19:13:08:58"
detect_movie_rotation() {
  local movie=$1

  local info=$(exiftool -Rotation -S "$movie")
    # replace ' ' with ':', and '::' with ':'
    info=${info// /:}
    info=${info//::/:}
    # echo -e "Info: $info"
    # $info is now in format "Rotation:180"

    # parse $info into variables
    read GARBAGE ROTATION <<<${info//:/ }
    # echo -e "Detected rotation: $ROTATION"

    echo "$ROTATION"
}

detect_movie_fps() {
  local movie=$1

  local info=$(exiftool -VideoFrameRate -S "$movie")
    # replace ' ' with ':', and '::' with ':'
    info=${info// /:}
    info=${info//./:}
    info=${info//::/:}
    #echo -e "Info: $info"
    # $info is now in format "VideoFrameRate:120:198"

    # parse $info into variables
    read GARBAGE FPS GARBAGEE <<<${info//:/ }

    echo "$FPS"
}

main() {

  check_if_dir_exist $sourceDir

  local fileIterator

  # correct [for] loop so that path and filename can contain special characters like spaces
  find $sourceDir -iname '*.mov' -or -iname '*.mp4' | while read fileIterator
  do
    # $fileIterator does not contain trailing slash '/'
    echo -e "\nProcessing file: $fileIterator"

    local info=$(find_datetime_taken_of_movie "$fileIterator")
    # $info is now in format "CreateDate:2014:07:19:13:08:58"

    # parse $info into variables
    read GARBAGE YEAR MONTH DAY HOUR MINUTE SECOND GARBAGE <<<${info//:/ }
    echo -e "Parsed datetime - year: $YEAR  month: $MONTH  day: $DAY  hour: $HOUR  min: $MINUTE  sec: $SECOND"

    # Get filename
    # local fileName=$(basename "$fileIterator")
    # echo -e "Filename: $fileName"

    # Get dirname
    local dirName=$(dirname "$fileIterator")
    # echo -e "Dir name: $dirName"

    # Get file extension
    local extName=${fileIterator##*.}
    # echo -e "Ext name: $extName"

    # rename movie
    mv "$fileIterator" "${dirName}/${YEAR}-${MONTH}-${DAY}--${HOUR}${MINUTE}${SECOND}.${extName}"
  done

  # correct [for] loop so that path and filename can contain special characters like spaces
  find $sourceDir -iname '*.mov' -or -iname '*.mp4' | while read fileIterator
  do

    local rotation=$(detect_movie_rotation "$fileIterator")
    echo -e "Detected rotation: $rotation"

    local fps=$(detect_movie_fps "$fileIterator")
    echo -e "Detected FPS: $fps"

    #re-encode movie
    ### original HandBrahe Normal preset
    ### ./HandBrakeCLI -i DVD -o ~/Movies/movie.mp4 -e x264  -q 20.0 -a 1 -E faac -B 160 -6 dpl2 -R Auto -D 0.0 --audio-copy-mask aac,ac3,dtshd,dts,mp3 --audio-fallback ffac3 -f mp4 --loose-anamorphic --modulus 2 -m --x264-preset veryfast --h264-profile main --h264-level 4.0
###    HandBrakeCLI -i "$fileIterator" \     # Set input device
###                 -o "${fileIterator}_tst.mp4" \  # Set output file name
###                 -e x264  \               # Set video library encoder
###                 -q 20.0 \                # Set video quality
###                 -a 1 \                   # Select audio track(s), separated by commas
###                 -E faac \                # Audio encoder
###                 -B 160 \                 # Set audio bitrate(s) <kb/s>
###                 -6 dpl2 \                # Format(s) for surround sound downmixing
###                 -R Auto \                # Set audio samplerate(s) (22.05/24/32/44.1/48 kHz)
###                 -D 0.0 \                 # Apply extra dynamic range compression to the audio, making soft sounds louder.
###                 --audio-copy-mask aac,ac3,dtshd,dts,mp3 \    # Set audio codecs that are permitted when the /copy/ audio encoder option is specified (aac/ac3/dts/dtshd/mp3, default: all).
###                 --audio-fallback ffac3 \ # Set audio codec to use when it is not possible to copy an audio track without re-encoding.
###                 -f mp4 \                 # forces a particular container file format
###                 --loose-anamorphic \     # Store pixel aspect ratio with specified width
###                 --modulus 2 \            # Set the number you want the scaled pixel dimensions to divide cleanly by.
###                 -m \                     # includes a chapter index in the video, based on the chapter times used in the source.
###                 --x264-preset veryfast \ # selects the x264 preset: ultrafast/superfast/veryfast/faster/fast/medium/slow/slower/veryslow/placebo
###                 --h264-profile main \    # tell x264 to conform to the specified H.264 profile (options: baseline, main, high, high10, high422, high444; default: high)
###                 --h264-level 4.0         # UNDOCUMENTED

    if [ "$fps" = "120" ]
    then
      # Get file extension
      local extName=${fileIterator##*.}
      # rename movie
      mv "$fileIterator" "${fileIterator}--120fps.${extName}"
      continue
    fi

    local rotationCmd=""
    if [ "$rotation" = "180" ]
    then
      rotationCmd="--rotate 3"
    fi

    if [ "$rotation" = "90" ]
    then
      rotationCmd=", --rotate=4"
    fi

    $(echo "" | HandBrakeCLI -i "${fileIterator}" \
               -o "${fileIterator}_out.mp4" \
               -e x264  \
               -q 20.0 \
               -a 1 \
               -E copy \
               -B 128 \
               -6 dpl2 \
               -R Auto \
               -D 0.0 \
               --audio-copy-mask aac \
               --audio-fallback faac \
               -f mp4 \
               --custom-anamorphic \
               -m \
               --x264-preset slower \
               --h264-profile main \
               --h264-level 4.0 \
               --large-file \
               --optimize \
               --cfr \
               --width 1280 \
               --height 720 \
               --crop 0:0:0:0 \
               ${rotationCmd} )

  done

  echo -e "\n\nScript DONE\n\n"

}
main