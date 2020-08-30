#!/bin/bash
dir=""
emoticon=""
files=1
specEmoName=0
error() {
  echo [ERROR]Failed to change directory...Check the log first.
  echo [ERROR]Please enter the correct parameters.
  echo [INFO]Exit...
  exit
}
ivarg() {
  echo [DEBUG]DIR: $dir, EMO: $emoticon
  echo [ERROR]Invaild args.
  echo [INFO]Exit...
  exit
}
rqarg() {
  echo [ERROR]DIR: $dir, EMO: $emoticon
  echo [ERROR]Invaild option. Is it requires args?
  echo [INFO]Exit...
  exit
}
para() {
  echo [DEBUG]DIR: $dir, EMO: $emoticon
  echo [ERROR]Please enter the parameters.
  echo [INFO]Exit...
  exit
}
while getopts :d:e: opts
do
  case $opts in
    d)
      dir=$OPTARG
      if [[ $dir == -* ]];then
          ivarg
      fi
      if [ $specEmoName = 0 ];then
        emoticon=$(basename $dir)
      fi
    ;;
    e)
      emoticon=$OPTARG
      specEmoName=1
      if [[ $emoticon == -* ]];then
        ivarg
      fi
    ;;
    *)
      rqarg
    ;;
  esac
done
if [ ! $dir ] || [ ! $emoticon ];then
  para
fi
echo [DEBUG]DIR: $dir, EMO: $emoticon
echo [INFO]Detecting files...
cd $dir
if [ $? -eq 1 ]; then
  error
fi
echo [INFO]Removing old index.json file...
rm index.json
for name in *;do mv ${name%.*} $emoticon$files $name; list[$files]="'$emoticon$files.${name##*.}',";echo [DEBUG]$name \>\> ${list[$files]%,}; files=$(expr $files + 1);done
echo [INFO]Writing list to index.json...
list[$(expr $files - 1)]=${list[$(expr $files - 1)]%,}
echo "{\"0\":["${list[*]}"]}" >> index.json
echo [INFO]Done.
