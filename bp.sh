source env.sh 

## optional parms
comp="$1"

echo "########## Build POSIX Sandbox ##########"

outp="out/posix"

if [ -d $outp ]; then
  echo "Removing current '$outp' directory..."
  $outp/$api stop
  sleep 2
  sudo rm -rf $outp
fi

./startTEST-REPO.sh
./build.sh -X posix -R

cp startREST-API.sh $outp/.

cd $outp

./$api key insert $USER-pubkey ubuntu ~/keys/$USER-pubkey.pem
./$api key insert lussier-io-east2-key ubuntu ~/keys/lussier-io-east2-key.pem
./$api cloud create aws       west2 us-west-2
./$api cloud create aws       east2 us-east-2 --default-ssh-key=lussier-io-east2-key
./$api cloud create openstack nnj2 --region=nnj2 --keys=$HOME/.openstack/nnj2.env --default-ssh-key=$USER-pubkey
./$api cloud create openstack nnj3 --region=nnj3 --keys=$HOME/.openstack/nnj3.env --default-ssh-key=$USER-pubkey

./$api set GLOBAL REPO http://localhost:8000
./$api info

if [ ! "$1" == "" ]; then
  if [ "$1" == "REST-API" ]; then
    ./startREST-API.sh
  else
    ./$api install $comp
  fi
fi

