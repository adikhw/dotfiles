# ~/.profile -- POSIX login shells (sh, dash, ...).
# Same shared environment as bash and zsh.
if [ -f "$HOME/.config/shell/env.sh" ]; then
    . "$HOME/.config/shell/env.sh"
fi
