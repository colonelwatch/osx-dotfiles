if status is-interactive
    # Commands to run in interactive sessions can go here
    macchina
    fish_config theme choose solarized --color-theme=light
    set fish_greeting
end

set NPROC "$(sysctl -n hw.logicalcpu)"

set -gx EDITOR nvim

fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$(brew --prefix rustup)/bin"

# pyenv
set -gx PYENV_ROOT "$HOME/.pyenv"
fish_add_path -g "$PYENV_ROOT/bin"
pyenv init - fish | source
set -gx PYTHON_CONFIGURE_OPTS '--enable-optimizations --with-lto'
set -gx PYTHON_CFLAGS '-mcpu=native'
set -gx MAKE_OPTS "-j$NPROC"

# build parallelism
set -gx CMAKE_BUILD_PARALLEL_LEVEL "$NPROC"
set -gx MAKEFLAGS "-j$NPROC"
