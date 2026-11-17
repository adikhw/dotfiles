# shellcheck shell=sh
# ~/.config/shell/env.sh
#
# SINGLE SOURCE OF TRUTH for PATH (and portable aliases) on this machine.
#
# Sourced by ~/.zshenv, ~/.zshrc, ~/.bashrc, ~/.bash_profile and ~/.profile,
# so bash, zsh and plain sh all resolve the same commands. Edit THIS file when
# you add a new binary directory -- never the individual rc files -- so the
# shells cannot drift apart again.
#
# Written in POSIX sh (no bashisms) so ~/.profile works under dash too.

# --- User-owned binary directories, highest priority first ---
#   .local/bin            pip --user, hand-dropped tools
#   .npm-global/bin       npm -g (opencode, tsc, tsx, ...)
#   go/bin                go install
#   .cargo/bin            rustup / cargo install
#   flatpak exports/bin   CLI wrappers for Flatpak apps (com.spotify.Client, ...)
_envsh_user_dirs="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/share/flatpak/exports/bin:/var/lib/flatpak/exports/bin"

# Fast path: already in the right shape (a previous rc file ran us, or the
# desktop session already supplied exactly this PATH). Keeps every repeat
# sourcing free of forks and free of duplicate entries.
case "$PATH" in
    "$_envsh_user_dirs" | "$_envsh_user_dirs":*) ;;
    *)
        # Rebuild: drop any old copies of the user dirs, then put them first.
        # zsh does not word-split unquoted expansions, hence the ${=PATH} form.
        _envsh_rest=""
        _envsh_old_ifs=$IFS
        IFS=:
        if [ -n "${ZSH_VERSION:-}" ]; then
            for _envsh_dir in ${=PATH}; do
                case ":$_envsh_user_dirs:" in
                    *":$_envsh_dir:"*) ;;
                    *) _envsh_rest="${_envsh_rest:+$_envsh_rest:}$_envsh_dir" ;;
                esac
            done
        else
            for _envsh_dir in $PATH; do
                case ":$_envsh_user_dirs:" in
                    *":$_envsh_dir:"*) ;;
                    *) _envsh_rest="${_envsh_rest:+$_envsh_rest:}$_envsh_dir" ;;
                esac
            done
        fi
        IFS=$_envsh_old_ifs
        PATH="$_envsh_user_dirs${_envsh_rest:+:$_envsh_rest}"
        unset _envsh_rest _envsh_old_ifs
        ;;
esac

# --- Always keep the standard system directories at the end ---
# Protects cron jobs, systemd units, `ssh host cmd`, `env -i ...` and other
# contexts that start with a minimal or empty PATH.
for _envsh_dir in /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin; do
    case ":$PATH:" in
        *":$_envsh_dir:"*) ;;
        *) PATH="$PATH:$_envsh_dir" ;;
    esac
done

unset _envsh_dir
export PATH

# --- Aliases that make sense in every shell ---
# Spotify is installed as a Flatpak: the exported command is com.spotify.Client,
# there is no `spotify` binary.
alias spotify='flatpak run com.spotify.Client'
