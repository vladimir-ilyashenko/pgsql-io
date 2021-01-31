COMP=components
SVCS=services

sqlite3 local.db < ../../src/conf/components.sql
sqlite3 local.db < ../../src/conf/versions.sql

python3 $COMP.py > html/$COMP.html
python3 $SVCS.py > html/$SVCS.html

