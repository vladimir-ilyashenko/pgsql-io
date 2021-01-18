COMP=components

sqlite3 local.db < ../../src/conf/components.sql
sqlite3 local.db < ../../src/conf/versions.sql

python3 $COMP.py > html/$COMP.html

