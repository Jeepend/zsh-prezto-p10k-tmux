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

for rcfile in $(ls ${ZDOTDIR:-$HOME}/.zprezto/runcoms/* | xargs -n 1 basename | grep -v README); do
    target="${ZDOTDIR:-$HOME}/.${rcfile:t}"
    ln -sf "${ZDOTDIR:-$HOME}/.zprezto/runcoms/${rcfile}" "${target}"
done

cp zpreztorc "${HOME}"/.zpreztorc
cp tmux.conf "${HOME}"/.tmux.conf
cp p10k.zsh "${HOME}"/.p10k.zsh

echo "[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh" >> "${HOME}"/.zshrc