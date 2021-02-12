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

./startHTTP.sh
./build.sh -X posix -R

#cp api.sh $outp/.

cd $outp

./$api key insert denisl-pubkey ubuntu ~/keys/denisl-pubkey.pem
./$api key insert lussier-io-east2-key ubuntu ~/keys/lussier-io-east2-key.pem
./$api cloud create openstack nnj3 --default-ssh-key=denisl-pubkey
#./$api cloud create aws       west2 us-west-2
#./$api cloud create aws       east2 us-east-2 --default-ssh-key=lussier-io-east2-key

./$api set GLOBAL REPO http://localhost:8000
./$api info

if [ ! "$1" == "" ]; then
  ./$api install $comp
fi

