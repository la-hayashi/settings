#!/bin/sh

# ${1} => "u" or "d"
# ${2} => "firefox" or "ie" or "safari"
# ${3} => "~@unstable" or "@unstable"

# selenium を起動している PC のIP
selenium_host=192.168.1.13
# selenium_host=192.168.1.65

# selenium を起動する時に指定した port 番号
selenium_port=4444

# サーバのIP
rails_host=`LANG=C /sbin/ifconfig | grep 'inet addr' | grep -v 127.0.0.1 | awk '{print $2;}' | cut -d: -f2`

# cucumber のオプション
opts=${3}

# テストするブラウザ
browser=${2}

# 実行するテストのディレクトリ
features_dir=features/functiontests/

if [ ${1} = u -o ${1} = d ] 2> /dev/null; then
  if [ ${2} = firefox -o ${2} = ie -o ${2} = safari ] 2> /dev/null; then 
    if [ ${3} = '~@unstable' -o ${3} = '@unstable' ] 2> /dev/null; then

      # ci_reporter の出力ファイルを削除
      rm -rf features/reports/
      sh /pub/reset.sh

      if [ ${1} = u ]; then
        bundle exec cucumber -p selenium --format rerun --out tmp_rerun.txt --format CI::Reporter::Cucumber --tags ~@exclude_mock_api --tags ~@manual --tags ${opts} SELENIUM_HOST=${selenium_host} SELENIUM_PORT=${selenium_port} SELENIUM_BROWSER=${browser} RAILS_HOST=${rails_host} ${features_dir}
      elif [ ${1} = d ]; then
        bundle exec rake ci:setup:cucumber cucumber:selenium FEATURE=${features_dir} SELENIUM_HOST=${selenium_host} SELENIUM_PORT=${selenium_port} SELENIUM_BROWSER=${browser} RAILS_HOST=${rails_host} CUCUMBER_OPTS="--format rerun --out tmp_rerun.txt --tags ~@exclude_mock_api --tags ${opts} "
      fi

      # length に tmp_rerun.txt のサイズを代入
      length=$(wc -c < tmp_rerun.txt)

      # length が 0でなければリトライを行う
      if [ ${length} -ne 0 ]; then
        # ci_reporter の出力ファイルを削除
        rm -rf features/reports/
        count=1

        # リトライを3回行う
        while [ ${count} -lt 4 ]; do
          echo ----------
          echo リトライ ${count}回目
          echo ----------

          cp tmp_rerun.txt rerun.txt 2> /dev/null
          if [ ${1} = u ]; then
            bundle exec cucumber -p selenium @rerun.txt --format rerun --out tmp_rerun.txt --format CI::Reporter::Cucumber --tags ~@exclude_mock_api --tags ~@manual --tags ${opts} SELENIUM_HOST=${selenium_host} SELENIUM_PORT=${selenium_port} RAILS_HOST=${rails_host} SELENIUM_BROWSER=${browser}
            # sh /pub/util_db_data/cp_db_util.sh
          elif [ ${1} = d ]; then
            bundle exec rake ci:setup:cucumber cucumber:selenium SELENIUM_HOST=${selenium_host} SELENIUM_PORT=${selenium_port} SELENIUM_BROWSER=${browser} RAILS_HOST=${rails_host} CUCUMBER_OPTS="@rerun.txt --format rerun --out tmp_rerun.txt --tags ~@exclude_mock_api --tags ${opts}"
          fi

          length=$(wc -c < tmp_rerun.txt)

          # length が 0 だった場合、each を抜ける(0=テストの成功)
          if [ ${length} -eq 0 ]; then
            echo リトライ ${count}回で成功しました

            rm tmp_rerun.txt 2> /dev/null
            rm rerun.txt 2> /dev/null
            break
          fi

          # リトライを 3回行い、成功しなかった場合、失敗したテスト一覧を出力
          if [ ${count} -eq 3 ]; then
            echo ${count}回リトライしたけど失敗しました
            echo エラーリスト
            echo ----------
            cat tmp_rerun.txt
            echo 
            echo ----------

            rm tmp_rerun.txt 2> /dev/null
            rm rerun.txt 2> /dev/null
            exit 1
          fi

          count=`expr $count + 1`
          sh /pub/reset.sh
        done
      else
        if [ ${length} -eq 0 ]; then
          rm tmp_rerun.txt 2> /dev/null
          rm rerun.txt 2> /dev/null
          echo 'リトライ無し(`･ω･´)ヾ'
        fi
      fi
    else
      echo -e '第3引数が間違っています("~@unstable" or "@unstable")'
      exit 1
    fi
  else
    echo -e '第2引数が間違っています("firefox" or "ie" or "safari")'
    exit 1
  fi
else
  echo -e '第1引数が間違っています("d" or "u")'
  exit 1
fi
