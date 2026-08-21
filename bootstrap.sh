#!/bin/bash

set -e

BREW_INSTALL_SH="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"


__brew_missing() {
    ! [ -x "$(command -v brew)" ]
}


__betterdisplay_missing() {
    __brew_missing || ! brew list --casks --full-name | grep -q betterdisplay
}


__fish_is_not_default() {
    [ "${SHELL##*/}" != "fish" ]
}


do_setup() {
    if __brew_missing || __fish_is_not_default || __betterdisplay_missing; then
        __launch_sudoloop_interactive
    fi

    if __brew_missing; then
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL "$BREW_INSTALL_SH")" && \
            eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        brew update
    fi
}


__launch_sudoloop_interactive() {
    sudo -v  # this is interactive, thereafter this function is non-interactive
    while true; do sleep 60; kill -0 $$ 2> /dev/null || exit; sudo -n -v; done &
}



do_root() {
    # install build dependencies with brew
    brew install -y \
        openssl@3 readline scdoc sqlite3 xz tcl-tk@8 libb2 zstd zlib pkgconfig

    # install runtime dependencies with brew
    brew install -y \
        font-jetbrains-mono-nerd-font node tree-sitter-cli

    # install applications with brew
    brew install -y \
        audacity betterdisplay cmake claude claude-code fd fish gh gimp     \
        git-lfs google-chrome htop macchina macs-fan-control markedit       \
        neovim netron nrf-connect parallel pipx pyenv qdirstat segger-jlink \
        tailscale-app raspberry-pi-imager ripgrep rsync rust rustup         \
        windows-app wireshark-app yazi zotero

    # declare brew-managed rust to rustup and make it the default
    __source_rustup &&                                              \
        rustup toolchain link system "$(brew --prefix rust)" &&     \
        rustup default system

    __install_alacritty

    # set fish as default for current user (needs sudo to be non-interactive)
    if __fish_is_not_default; then
        sudo chsh -s "$(command -v fish)" "$(id -un)"
    fi
}


__source_rustup() {
    export PATH="$(brew --prefix rustup)/bin:$PATH"
}


do_user() {
    # install user-local applications
    pipx install compiledb
    __source_pyenv && pyenv install --skip-existing 3.12 3.13 3.13t 3.14 3.14t

    mkdir -p ~/.cache/ssh  # make folder .ssh/config will expect

    # set up user config
    mkdir -p ~/.config && ln -s -f "$PWD"/home/.config/* ~/.config/
    mkdir -p ~/.ssh && ln -s -f "$PWD"/home/.ssh/* ~/.ssh/
    git lfs install
}


__source_pyenv() {
    export PYENV_ROOT="$HOME/.pyenv"
    if [ -d "$PYENV_ROOT/bin" ]; then
        export PATH="$PYENV_ROOT/bin:$PATH"
    fi
    eval "$(pyenv init - bash)"

    export PYTHON_CONFIGURE_OPTS='--enable-optimizations --with-lto'
    export PYTHON_CFLAGS='-mcpu=native'
    export MAKE_OPTS="-j$(sysctl -n hw.logicalcpu)"
}


__install_alacritty() (
    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    git clone --depth 1 https://github.com/alacritty/alacritty.git
    cd alacritty
    make app
    cp -r target/release/osx/Alacritty.app /Applications/
)


# check if pwd is ~/.dotfiles
if [ ! "$PWD" = "$HOME/.dotfiles" ]; then
    echo "Please run this script from the ~/.dotfiles directory."
    exit 1
fi

do_setup
do_root
do_user
