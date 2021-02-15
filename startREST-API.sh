
export MY_HOME=$PWD
export MY_CMD=io
export FLASK_APP=$MY_HOME/hub/scripts/restapi.py
export FLASK_ENV=development

rc=0
pid=`ps aux | grep "[f]lask" | awk '{print $2}'`
if [ "$pid" > " " ]; then
  echo "killing flask ($pid)"
  kill -9 $pid
  rc=$?
fi


if [ "$rc" == "0" ]; then
  flask run --host=0.0.0.0 &
fi
