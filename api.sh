
export MY_HOME=$PWD
export MY_CMD=io
export FLASK_APP=$MY_HOME/hub/scripts/web.py
export FLASK_ENV=development

pid=`ps aux | grep "[f]lask" | awk '{print $2}'`
if [ "$pid" > " " ]; then
  echo "killing ($pid)"
  kill -9 $pid
fi
rm -f " "

flask run --host=0.0.0.0 &
