#!/bin/bash
APP_ROOT="/home/`whoami`/capistrano/current"
export basename="rake_dwh_build_caches"

if [ -f ~/batches/pids/$basename.pid ]; then
  echo [rake_dwh_build_caches]$basename is working now. >> /home/`whoami`/capistrano/current/log/batch_production_rotate.log
  exit 0
fi

echo "select ruby version.."
echo "0:all"
echo "a:医学部"
echo "b:地域学部"
echo "c:工学部"
echo "d:農学部"
echo "e:持続性社会創生科学研究科"
echo "f:工学研究科"
echo "g:医学系研究科_後期"
echo "h:医学系研究科_前期"
echo "i:共同獣医学研究科"
echo "j:連合農学研究科"
echo "1:医学部/医学科"
echo "2:医学部/保健学科看護学専攻"
echo "3:医学部/生命科学科"
echo "4:医学部/保健学科検査技術科学専攻"
echo "5:地域学部/地域学科地域創造コース"
echo "6:地域学部/地域学科国際地域文化コース"
echo "7:地域学部/地域学科人間形成コース"
echo "8:工学部/電気情報系学科"
echo "9:工学部/化学バイオ系学科"
echo "10:工学部/社会システム土木系学科"
echo "11:工学部/社会システム土木系学科（土木）"
echo "12:工学部/社会システム土木系学科（社会）"
echo "13:農学部/共同獣医学科"
echo "14:農学部/生命環境農学科"
echo "15:農学部/生命環境農学科植物菌類生産科学コース"
echo "16:農学部/生命環境農学科国際乾燥地農学コース"
echo "17:農学部/生命環境農学科里地里山環境管理学コース"
echo "18:農学部/生命環境農学科農芸化学コース"
echo "19:持続性社会創生科学研究科/地域学専攻"
echo "20:持続性社会創生科学研究科/工学専攻"
echo "21:持続性社会創生科学研究科/農学専攻"
echo "22:持続性社会創生科学研究科/国際乾燥地科学専攻"
echo "23:工学研究科/社会基盤工学専攻"
echo "24:工学研究科/機械宇宙工学専攻"
echo "25:工学研究科/情報エレクトロニクス専攻"
echo "26:工学研究科/化学・生物応用工学専攻"
echo "27:工学研究科/工学専攻"
echo "28:医学系研究科_後期/医学専攻"
echo "29:医学系研究科_後期/医科学専攻後期"
echo "30:医学系研究科_前期/臨床心理学専攻"
echo "31:医学系研究科_前期/医科学専攻前期"
echo "32:共同獣医学研究科/共同獣医学専攻"
echo "33:連合農学研究科/生命資源科学専攻"
echo "34:連合農学研究科/生産環境科学専攻"
echo "35:連合農学研究科/国際乾燥地科学専攻"

read -p "choose no? " no
case "$no" in
  a)
    INST="医学部"
    DEPT=""
    ;;
  b)
    INST="地域学部"
    DEPT=""
    ;;
  c)
    INST="工学部"
    DEPT=""
    ;;
  d)
    INST="農学部"
    DEPT=""
    ;;
  e)
    INST="持続性社会創生科学研究科"
    DEPT=""
    ;;
  f)
    INST="工学研究科"
    DEPT=""
    ;;
  g)
    INST="医学系研究科_後期"
    DEPT=""
    ;;
  h)
    INST="医学系研究科_前期"
    DEPT=""
    ;;
  i)
    INST="共同獣医学研究科"
    DEPT=""
    ;;
  j)
    INST="連合農学研究科"
    DEPT=""
    ;;
  1)
    INST="医学部"
    DEPT="医学科"
    ;;
  2)
    INST="医学部"
    DEPT="保健学科看護学専攻"
    ;;
  3)
    INST="医学部"
    DEPT="生命科学科"
    ;;
  4)
    INST="医学部"
    DEPT="保健学科検査技術科学専攻"
    ;;
  5)
    INST="地域学部"
    DEPT="地域学科地域創造コース"
    ;;
  6)
    INST="地域学部"
    DEPT="地域学科国際地域文化コース"
    ;;
  7)
    INST="地域学部"
    DEPT="地域学科人間形成コース"
    ;;
  8)
    INST="工学部"
    DEPT="電気情報系学科"
    ;;
  9)
    INST="工学部"
    DEPT="化学バイオ系学科"
    ;;
  10)
    INST="工学部"
    DEPT="社会システム土木系学科"
    ;;
  11)
    INST="工学部"
    DEPT="社会システム土木系学科（土木）"
    ;;
  12)
    INST="工学部"
    DEPT="社会システム土木系学科（社会）"
    ;;
  13)
    INST="農学部"
    DEPT="共同獣医学科"
    ;;
  14)
    INST="農学部"
    DEPT="生命環境農学科"
    ;;
  15)
    INST="農学部"
    DEPT="生命環境農学科植物菌類生産科学コース"
    ;;
  16)
    INST="農学部"
    DEPT="生命環境農学科国際乾燥地農学コース"
    ;;
  17)
    INST="農学部"
    DEPT="生命環境農学科里地里山環境管理学コース"
    ;;
  18)
    INST="農学部"
    DEPT="生命環境農学科農芸化学コース"
    ;;
  19)
    INST="持続性社会創生科学研究科"
    DEPT="地域学専攻"
    ;;
  20)
    INST="持続性社会創生科学研究科"
    DEPT="工学専攻"
    ;;
  21)
    INST="持続性社会創生科学研究科"
    DEPT="農学専攻"
    ;;
  22)
    INST="持続性社会創生科学研究科"
    DEPT="国際乾燥地科学専攻"
    ;;
  23)
    INST="工学研究科"
    DEPT="社会基盤工学専攻"
    ;;
  24)
    INST="工学研究科"
    DEPT="機械宇宙工学専攻"
    ;;
  25)
    INST="工学研究科"
    DEPT="情報エレクトロニクス専攻"
    ;;
  26)
    INST="工学研究科"
    DEPT="化学・生物応用工学専攻"
    ;;
  27)
    INST="工学研究科"
    DEPT="工学専攻"
    ;;
  28)
    INST="医学系研究科_後期"
    DEPT="医学専攻"
    ;;
  29)
    INST="医学系研究科_後期"
    DEPT="医科学専攻後期"
    ;;
  30)
    INST="医学系研究科_前期"
    DEPT="臨床心理学専攻"
    ;;
  31)
    INST="医学系研究科_前期"
    DEPT="医科学専攻前期"
    ;;
  32)
    INST="共同獣医学研究科"
    DEPT="共同獣医学専攻"
    ;;
  33)
    INST="連合農学研究科"
    DEPT="生命資源科学専攻"
    ;;
  34)
    INST="連合農学研究科"
    DEPT="生産環境科学専攻"
    ;;
  35)
    INST="連合農学研究科"
    DEPT="国際乾燥地科学専攻"
    ;;
  *)
    INST=""
    DEPT=""
    ;;
esac


mkdir -p ~/batches/pids
echo $$ > ~/batches/pids/$basename.pid

source ~/.bash_profile
cd ${APP_ROOT}

rake RAILS_ENV=production RBASE_LOG_NAME=batch_production lti:dwh_build_caches[${INST},${DEPT}]
rake_exit_code=$?

rm -f ~/batches/pids/$basename.pid
exit $rake_exit_code
