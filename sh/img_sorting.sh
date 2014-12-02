#!/bin/sh

langs=("de" "en" "es" "fr" "it" "ja" "nl" "pt" "ru" "sv" "zh-HANS" "zh-HANT")
files="./*"

for lang in ${langs[@]}; do
  mkdir $lang 2> /dev/null; 
  for file in ${files[@]}; do
    if [ `echo $file|grep _${lang}.png` ]; then
      mv $file ./$lang  2> /dev/null
    fi
  done
done
