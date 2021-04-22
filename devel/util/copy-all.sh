outD=out-20210430

if [ ! "$1" == "prod" ]; then
  echo "invalid 1st parm"
  exit 1
fi

rm -rf history/$outD
mkdir history/$outD

cp -p $OUT/* history/$outD/.
rm -f history/$outD/pgsql-1*
rm -f history/$outD/pgsql-9*

./copy-to-s3.sh $1 $outD
