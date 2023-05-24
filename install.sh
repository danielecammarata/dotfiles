#!/bin/bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

# inspired by
# https://gist.github.com/codeinthehole/26b37efa67041e1307db
# https://github.com/why-jay/osx-init/blob/master/install.sh
# https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh

# PRECONDITIONS
# 1)
# make sure the file is executable
# chmod +x osx_bootstrap.sh
#
# 2)
# Your password may be necessary for some packages
#
# 3)
# https://docs.brew.sh/Installation#macos-requirements
# xcode-select --install
# (_xcode-select installation_ installs git already, however git will be installed via brew packages as well to install as much as possible the brew way
#  this way you benefit from frequent brew updates)
# 
# 4) don't let the “Operation not permitted” error bite you
# Please make sure you system settings allow the termianl full disk access
# https://osxdaily.com/2018/10/09/fix-operation-not-permitted-terminal-error-macos/

# `set -eu` causes an 'unbound variable' error in case SUDO_USER is not set
SUDO_USER=$(whoami)

# Check for Homebrew, install if not installed
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew update
brew upgrade

# find the CLI Tools update
echo "find CLI tools update"
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true
# install it
if [[ ! -z "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

# alfred
# tmux
# rectangle

PACKAGES=(
    ack
    alfred
    asdf
    autojump
    bash
    # fnm
    gcc
    git
    hstr
    httpie
    hub
    imagemagick
    lynx
    markdown
    node
    rename
    ripgrep
    the_silver_searcher
    tig
    tree
    watch
    wget
    zsh
    yarn
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

CASKS=(
    airflow
    apptivate
    awareness
    chromium
    espanso
    firefox
    google-chrome
    grammarly
    # Error: The cask 'keepassxc' was affected by a bug and cannot be upgraded as-is
    # keepassxc
    keepingyouawake
    pycharm
    rectangle
    secure-pipes
    shuttle
    slack
    tiles
    visual-studio-code
    vlc
    whatsapp
    zoom
    xnviewmp
    zoxide
    warp
)

echo "Installing cask apps..."
sudo -u $SUDO_USER brew install --cask ${CASKS[@]}

echo "Installing docker..."
sudo -u $SUDO_USER brew install --cask docker

echo "Installing oh-my-zsh..."
/bin/bash -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


echo "Cleaning up"
brew cleanup
echo "Ask the doctor"
brew doctor

echo "OSX bootstrapping done"