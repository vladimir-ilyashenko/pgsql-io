outD=out-20210305

rm -rf history/$outD
mkdir history/$outD

cp -p $OUT/* history/$outD/.
rm history/$outD/openrds-1*

./copy-to-s3.sh $outD
