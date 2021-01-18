

## Determine the Package Manager (PKMG) & OS Major Version (VER_OS)

yum --version > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  export PKMG=yum
  export VER_OS=`cat /etc/os-release | grep VERSION_ID | cut -d= -f2 | tr -d '\"'`
else
  export PKMG=apt
  export VER_OS=`lsb_release -cs`
fi

