# PGSQL-IO for ~/.bash... ############################################################
alias git-push="cd ~/dev/pgsql-io; git status; git add .; git commit -m wip; git push"
alias bp="cd ~/dev/pgsql-io; . ./bp.sh"
alias ver="vi ~/dev/pgsql-io/src/conf/versions.sql"

export REGION=us-west-2

cat /etc/os-release | grep el8 > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  export BUCKET=s3://pgsql-io-download-el8
else
  export BUCKET=s3://pgsql-io-download
fi

export DEV=$HOME/dev
export IN=$DEV/in
export OUT=$DEV/out
export HIST=$DEV/history
export IO=$DEV/pgsql-io
export SRC=$IN/sources
export BLD=/opt/pgbin-build/pgbin/bin

export HTML=$IO/web/static
export IMG=$HTML/html/img
export DEVEL=$IO/devel
export PG=$DEVEL/pg
export CLI=$IO/cli/scripts
export REPO=http://localhost:8000

export JAVA_HOME=/etc/alternatives/jre_11_openjdk

export PATH=/usr/local/bin:$JAVA_HOME/bin:$PATH
