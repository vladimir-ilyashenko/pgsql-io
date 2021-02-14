# OPENRDS 

EMAIL="denis@lussier.io"
NAME="denis lussier"
git config --global user.email "$EMAIL"
git config --global user.name "$NAME"
git config --global push.default simple
git config --global credential.helper store
git config --global pull.rebase false

mkdir -p ~/dev
cd ~/dev
mkdir -p in
mkdir -p out
mkdir -p history

pip --version 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  cd ~
  wget https://bootstrap.pypa.io/get-pip.py
  sudo python3 get-pip.py
  rm get-pip.py
fi

aws --version 2>&1
rc=$?
if [ ! "$rc" == "0" ]; then
  pip3 install --user awscli
  mkdir -p ~/.aws
  cd ~/.aws
  touch config
  # vi config
  chmod 600 config
fi

cd ~/dev/openrds
if [ -f ~/.bashrc ]; then
  bf=~/.bashrc
else
  bf=~/.bash_profile
fi
grep IO $bf
rc=$?
if [ ! "$rc" == "0" ]; then
  cat bash_profile >> $bf
fi

echo ""
echo "Goodbye!"
