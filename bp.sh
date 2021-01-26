source env.sh 

## optional parms
comp="$1"

echo "########## Build POSIX Sandbox ##########"

outp="out/posix"

if [ -d $outp ]; then
  echo "Removing current '$outp' directory..."
  $outp/$api stop
  sleep 2
  rm -rf $outp
fi

./startHTTP.sh
./build.sh -X posix -R

#cp api.sh $outp/.

cd $outp

#./api.sh 
./$api cloud create pgsql
./$api cloud create aws west2 us-west-2
./$api cloud create aws east2 us-east-2
./$api key insert denisl-pubkey ubuntu ~/keys/denisl-pubkey.pem
./$api key insert lussier-io-east2-key ubuntu ~/keys/lussier-io-east2-key.pem

./$api set GLOBAL REPO http://localhost:8000
./$api info

if [ ! "$1" == "" ]; then
  ./$api install $comp
fi

