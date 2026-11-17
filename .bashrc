# ~/.bashrc  (canonical copy is in ~/dotfiles; ~/.bashrc is a symlink to it)

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# PATH + shared aliases: one file, also used by zsh and sh.
. "$HOME/.config/shell/env.sh"

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# --- kurta dev setup ---
alias ls='eza --icons'
alias cat='bat'
alias vim='nvim'

# Prompt only in interactive shells (keeps `bash -c` fast and quiet).
case $- in
    *i*) eval "$(starship init bash)" ;;
esac
