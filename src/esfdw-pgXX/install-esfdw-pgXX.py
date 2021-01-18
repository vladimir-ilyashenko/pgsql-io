 
####################################################################
######          Copyright (c)  2015-2020 BigSQL           ##########
####################################################################

import util, os, sys

cmd='python3 -m pip install --user elasticsearch'
print('   ' + cmd)
os.system(cmd)

esfdwV = str(sys.argv[1])
cmd="python3 -m pip install --user pg_es_fdw='" + esfdwV + "'"
print('   ' + cmd)
os.system(cmd)

