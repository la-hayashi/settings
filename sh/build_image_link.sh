#!/bin/sh1{}

# ${1} => "u" "d"

browsers=("Firefox" "IE8" "IE9" "IE10" "IE11")
langs=("de" "en" "es" "fr" "it" "ja" "nl" "pt" "ru" "sv" "zh-HANS" "zh-HANT")

for lang in ${langs[@]};do
  if [ ${1} = u ] 2> /dev/null; then
    app=u_hoge
    files=(
             "u_hoge_${lang}.png"
    )
  elif [ ${1} = d ] 2> /dev/null; then
    app=d_hoge
    files=(
             "d_hoge_${lang}.png"
    )
  else
    echo "error"
    exit 1
  fi

  for browser in ${browsers[@]}; do
    md+=`echo "[[Home]] > [[hoge]] > [[${browser}]]\n"`
    md+=`echo "\n"`
    md+=`echo "#### $browser: $lang\n"`
    md+=`echo "\n"`
    for file in ${files[@]}; do
      url="[![image](/hoge/${app}/raw/image/${browser}/${lang}/${file})](/hoge/${app}/raw/image/${browser}/${lang}/${file})"
      md+=`echo "* ${file}\n"`
      md+=`echo "$url\n"`
    done
    file_name=`echo "./$browser:-$lang.md"`
    echo -e $md > `echo $file_name`
    md=""
  done
done