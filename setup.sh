#!/bin/bash
# Simple setup.sh for configuring Ubuntu 14.04 LTS EC2 instance
# for headless setup. 

# Correct locale setting (since .bash_profile not used yet for this session)
export LANGUAGE=en_US:en
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales

# Install git
sudo apt-get install -y git

# Install node.js via package manager (npm is included in chris lea's nodejs package)
# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get -qq update
sudo apt-get install -y nodejs

# Install node version manager to switch versions easily
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.12.1/install.sh | bash



# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
#sudo add-apt-repository -y ppa:cassou/emacs
#sudo apt-get -qq update
#sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install tmuxinator (help for setting tmux sessions)
sudo gem install tmuxinator

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
#if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
#fi
git clone https://github.com/clsdx/dotfiles.git dotfiles
. ~/dotfiles/.install.sh

# update bash profile
. ~/.bash_profile

#source (bash/vim)rc
source ~/.bashrc
source ~/.vimrc

#for poor tibotiber's emacs delusion:
git clone https://github.com/tibotiber/ec2-dotfiles.git

ln -sb ~/ec2-dotfiles/.tmuxinator ~/
ln -sf ~/ec2-dotfiles/.emacs.d ~/

# source completion file for tmuxinator
source .tmuxinator/tmuxinator.bash

# Install sails.js MVC framework for node.js -> changed to non global via npm.
#sudo npm -g install sails

# Install MQTT tools
sudo apt-get install -y mosquitto python-mosquitto mosquitto-clients
sudo rm /etc/init/mosquitto.conf # because I don't want mosquitto as a startup service
#sudo npm -g install mosca # mosca installed globally if not included in ubismart

# Install i386 architecture & system-level 32bit libs to run yap (eye)
# This bit is Ubuntu 14.04 specific!
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
# Install yap specific 32bit lib
sudo apt-get install -y zlib1g:i386

# Install zeromq-node binaries so that npm install zmq works
# https://github.com/JustinTulloss/zeromq.node/wiki/Installation
sudo add-apt-repository -y ppa:chris-lea/zeromq
sudo add-apt-repository -y ppa:chris-lea/libpgm
sudo apt-get update
sudo apt-get install -y libzmq3-dev
sudo apt-get install -y python-software-properties python g++ make

# config for efficient git
git config --global user.name "Cyril Seydoux"
ssh-keygen -t rsa -N "" -C "c.seydoux@gmx.com" -f ~/.ssh/id_rsa
ssh-add id_rsa
echo "You should copy the next line into a new ssh key on github (https://github.com/settings/ssh)."
cat ~/.ssh/id_rsa.pub
echo "Then you can run 'ssh -T git@github.com' to check that the connection is working."
