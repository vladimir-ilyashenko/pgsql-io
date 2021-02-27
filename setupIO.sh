# OPENRDS 

echo "Enter git user.email"
read user_email

echo "Enter git user.name"
read user_name

git config --global user.email "$user_email"
git config --global user.name "$user_name"
git config --global push.default simple
git config --global credential.helper store
git config --global pull.rebase false

mkdir -p ~/dev
cd ~/dev
mkdir -p in
mkdir -p out
mkdir -p history

echo ""
which pip3 > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  echo "## skipping PIP3 setup"
else
  echo "## PIP3 setup ########"
  cd ~
  wget https://bootstrap.pypa.io/get-pip.py
  sudo python3 get-pip.py
  rm get-pip.py
fi


echo ""
cd ~/dev/pgsql-io
if [ -f ~/.bashrc ]; then
  bf=~/.bashrc
else
  bf=~/.bash_profile
fi
grep IO $bf > /dev/null 2>&1
rc=$?
if [ "$rc" == "0" ]; then
  echo "## Skipping BASH_PROFILE setup"
else
  echo "## BASH_PROFILE setup ###"
  cp bash_profile bash_profile2
  echo " " >> bash_profile2
  echo "export USER_EMAIL=\"$user_email\"" >> bash_profile2
  echo "export USER_NAME=\"$user_name\"" >> bash_profile2
  cat bash_profile2 >> $bf
  rm bash_profile2
  source $bf
fi

echo ""
echo "Goodbye!"
