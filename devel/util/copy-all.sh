outD=out-20201112

rm -rf history/$outD
mkdir history/$outD

cp -p $OUT/* history/$outD/.
rm history/$outD/pgsql-1*

./copy-to-s3.sh $outD
