#!/bin/bash
# Default options
#################
sxiv_opts=" -tpo -z 200"
range=3
from=1
source="wallpaper.csv"
################


# getting options
#################
while getopts r:s:f: flags
do
  case "${flags}" in
    r) range=${OPTARG};;
    f) from=${OPTARG};;
    s) source=${OPTARG};;
  esac
done


# Making temp files
###################
tempFile=$(mktemp --tmpdir thumbnail.XXXX)
tempDir=$(mktemp -d --tmpdir thumbnailFile.XXXX)
tempWallDir=$(mktemp -d --tmpdir wallpaper.XXXX)
###################


# Copying wallpaper csv file to tempFile
########################################
datafile=$(awk -F ',' ''"NR>=$from && NR<$(($range + $from))"'{print $1"|"$2"|"$3}' $source)
printf "%s\n" "$datafile" > "$tempFile"
########################################


# Downloading the thumbnail
###########################
i=1
while read line
do
    fileName=$(echo $line | awk -F '|' '{print $1}')
    fileUrl=$(echo $line | awk -F '|' '{print $2}')
    fileThumbnail=$(echo $line | awk -F '|' '{print $3}')
    curl -s -o ${fileName} --output-dir "${tempDir}" "${fileThumbnail}"

    if [[ $i -eq $range ]]; then
        break
    fi
    ((i++))
done < $tempFile
############################


# Getting which file is marked only work on the first selected image
####################################################################
image_names=$(sxiv $sxiv_opts "$tempDir" | tr ' ' '\n')
image_name=$(echo $image_names | awk -F '/' '{print  $4}')
####################################################################


# Setting wallpaper
###################
i=1
while read line
do
  fileName=$(echo $line | awk -F '|' '{print $1}')
  fileUrl=$(echo $line | awk -F '|' '{print $2}')
  fileThumbnail=$(echo $line | awk -F '|' '{print $3}')

  if [[ "$fileName" = "${image_name}" ]]; then
    curl -sL -o ${fileName} --output-dir "${tempWallDir}" "${fileUrl}"
    ~/.config/polybar/material/scripts/pywal.sh "${tempWallDir}/${fileName}"
  fi

  if [[ $i -eq $range ]]; then
      break
  fi
  ((i++))
done < $tempFile
#####################
