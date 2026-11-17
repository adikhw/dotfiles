#!/bin/sh
# shell-doctor -- verify the shared shell setup from inside the shell you run
# it in. Exit status 0 means everything is wired up.
#
#   shell-doctor          human readable
#   shell-doctor --quiet  only problems (handy in scripts)
#
# Installed as ~/.local/bin/shell-doctor by ~/dotfiles/install.sh.

quiet=0
[ "${1:-}" = "--quiet" ] && quiet=1

fail=0
ok()  { [ "$quiet" -eq 1 ] || printf '  ok    %s\n' "$*"; }
bad() { printf '  FAIL  %s\n' "$*"; fail=1; }
head_() { [ "$quiet" -eq 1 ] || printf '\n%s\n' "$*"; }

if [ -n "${ZSH_VERSION:-}" ]; then
    shell_name=zsh
elif [ -n "${BASH_VERSION:-}" ] && [ "${BASH_SOURCE[0]:-}" != "$0" ]; then
    shell_name=bash
else
    # Executed as a child process, so our own interpreter is /bin/sh (bash, but
    # that is not what the user typed). Report the invoking shell instead.
    shell_name=$(cat "/proc/$PPID/comm" 2>/dev/null || echo sh)
fi

[ "$quiet" -eq 1 ] || printf 'shell-doctor  |  running in %s  |  %s PATH entries\n' \
    "$shell_name" "$(printf '%s' "$PATH" | tr ':' '\n' | wc -l)"

head_ 'directories:'
for d in \
    "$HOME/.local/bin" \
    "$HOME/.npm-global/bin" \
    "$HOME/go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.local/share/flatpak/exports/bin" \
    /var/lib/flatpak/exports/bin
do
    [ -d "$d" ] || continue
    case ":$PATH:" in
        *":$d:"*) ok "$d" ;;
        *) bad "$d exists but is NOT in PATH" ;;
    esac
done

head_ 'commands:'
for c in opencode node npm cargo go flatpak git; do
    if p=$(command -v "$c" 2>/dev/null); then
        ok "$c -> $p"
    else
        bad "$c not found in PATH"
    fi
done

head_ 'spotify:'
if flatpak info com.spotify.Client >/dev/null 2>&1; then
    ok 'flatpak com.spotify.Client installed'
else
    bad 'flatpak com.spotify.Client is not installed'
fi
if grep -q "alias spotify=" "$HOME/.config/shell/env.sh" 2>/dev/null; then
    ok "alias spotify -> flatpak run com.spotify.Client"
else
    bad 'alias spotify missing from ~/.config/shell/env.sh'
fi

head_ 'config wiring:'
wired() { # $1 = file, $2 = pattern that proves it loads the shared env
    path="$HOME/$1"
    if [ ! -r "$path" ]; then
        bad "$path missing"
    elif ! grep -q "$2" "$path"; then
        bad "$path does not load the shared env"
    elif [ -L "$path" ]; then
        ok "$path -> $(readlink "$path")"
    else
        bad "$path is a real file, not a link into ~/dotfiles"
    fi
}
wired .zshenv        'shell/env.sh'
wired .zshrc         'shell/env.sh'
wired .bashrc        'shell/env.sh'
wired .bash_profile  'bashrc\|shell/env.sh'   # .bash_profile pulls in .bashrc
wired .profile       'shell/env.sh'

conf="$HOME/.config/environment.d/10-user-path.conf"
gen=/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator
if [ -r "$conf" ] && [ -x "$gen" ]; then
    session_path=$("$gen" 2>/dev/null | sed -n 's/^PATH=//p')
    case ":$session_path:" in
        *":$HOME/.npm-global/bin:"*) ok 'desktop/GUI session PATH' ;;
        *) bad 'desktop session PATH (log out and back in, then re-check)' ;;
    esac
else
    bad "$conf missing"
fi

if [ "$fail" -ne 0 ]; then
    [ "$quiet" -eq 1 ] || printf '\nSomething is off. Re-run: ~/dotfiles/install.sh\n'
    exit 1
fi

[ "$quiet" -eq 1 ] || printf '\nAll good.\n'
exit 0
