#!/bin/bash

function setup(){
    set -xe
    apt install -y --no-install-recommends ca-certificates apt-transport-https
    sed -i "s@http://.*archive.ubuntu.com@https://repo.huaweicloud.com@g" /etc/apt/sources.list
    sed -i "s@http://.*security.ubuntu.com@https://repo.huaweicloud.com@g" /etc/apt/sources.list
    apt update
    apt install -y curl tmux zsh git
}

FUNC=$(declare -f setup)

current_user=$(whoami)
echo "Current user: ${current_user}"
if [ ${current_user} == "root" ];
then
    setup
else
    sudo bash -c "$FUNC; setup"
fi

chsh -s /bin/zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

cp zpreztorc "${HOME}"/.zpreztorc
cp tmux.conf "${HOME}"/.tmux.conf
cp p10k.zsh "${HOME}"/.p10k.zsh
