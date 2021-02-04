
import util
import os, sys

pgver="pg9X"

isAutoStart = str(os.getenv("isAutoStart", "False"))
print("isAutoStart = " + str(isAutoStart))

if isAutoStart != "True":
  sys.exit(0)


######################################
## AutoStart 
#####################################

thisDir = os.path.dirname(os.path.realpath(__file__))
svcuser = util.get_user()

print("Initializing " + str(pgver) + " as a service to run as " + str(svcuser))
script = thisDir + os.sep + "init-" + pgver + ".py --svcuser=" + str(svcuser)
cmd = sys.executable + " -u " + script
rc = os.system(cmd)

print("Configuring " + str(pgver) + " to Autostart")
script = thisDir + os.sep + "config-" + pgver + ".py --autostart=on"
cmd = sys.executable + " -u " + script
rc = os.system(cmd)

print("Starting " + str(pgver) + " for first time")
script = thisDir + os.sep + "start-" + pgver + ".py"
cmd = sys.executable + " -u " + script
rc = os.system(cmd)

# This script runs after the install script succeeds and must
# therefore always return success
sys.exit(0)

