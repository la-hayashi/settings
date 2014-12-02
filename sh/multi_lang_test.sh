#!/bin/sh

# selenium を起動している PC のIP
selenium_host=${1}

# selenium を起動する時に指定した port 番号
selenium_port=${2}

browser=${3}

# サーバのIP
rails_host=`LANG=C /sbin/ifconfig | grep 'inet addr' | grep -v 127.0.0.1 | awk '{print $2;}' | cut -d: -f2`

langs=("de" "en" "es" "fr" "it" "ja" "nl" "pt" "ru" "sv" "zh-HANS" "zh-HANT")

if [ ${1} ] 2> /dev/null;then
  if [ ${2} ] 2> /dev/null;then
    if [ ${3} ] 2> /dev/null;then
      for lang in ${langs[@]};do
        echo -e "----------------"
        echo -e "${lang}"
        echo -e "----------------"
        bundle exec rake cucumber:screen_capture SELENIUM_HOST=${selenium_host} SELENIUM_PORT=$selenium_port SELENIUM_BROWSER=$browser RAILS_HOST=$rails_host GUITEST_LANG=$lang FEATURE=features/guitests/
      done
    else
      echo -e "3引数エラー"
      exit 1
    fi
  else
    echo -e "2引数エラー"
  fi
else
  echo -e "3引数エラー"
fi
