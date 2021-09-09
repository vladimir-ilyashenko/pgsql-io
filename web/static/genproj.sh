
proj="$1"
if [ "$proj" == "" ]; then
  proj=project
fi

f_out=html/$proj.html

python3 project.py $proj > $f_out

sudo cp -v html/$proj.html    /var/www/html/.
sudo cp -r html/img /var/www/html/


