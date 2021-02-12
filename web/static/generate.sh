SVCS=services

sqlite3 local.db < ../../src/conf/components.sql
sqlite3 local.db < ../../src/conf/versions.sql

python3 $SVCS.py > html/$SVCS.html

