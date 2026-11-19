# ~/.zshrc — canonical copy ada di ~/dotfiles/.zshrc
# ~/.zshrc adalah symlink ke file ini.
#
# Tema: graphite / macOS Tahoe.
# Struktur: environment -> history -> completion -> tools -> plugin -> warna.
# Plugin dimuat PALING AKHIR dan syntax-highlighting adalah yang terakhir,
# supaya widget dari fzf/zoxide/starship tidak menimpa highlighting.

# --- Environment -----------------------------------------------------------
# PATH + alias portable (dipakai juga oleh bash/sh).
. "$HOME/.config/shell/env.sh"

# --- History ---------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory sharehistory incappendhistory
setopt histignorealldups histreduceblanks histverify histignorespace
setopt extendedhistory

# --- Perilaku shell --------------------------------------------------------
setopt autocd
unsetopt beep

# --- Completion ------------------------------------------------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%F{#7d8590}-- %d --%f'

# --- Alias: eza ------------------------------------------------------------
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza -lh --icons --group-directories-first --git'
  alias la='eza -lah --icons --group-directories-first --git'
  alias lt='eza --tree --level=2 --icons'
fi

# --- Alias: bat ------------------------------------------------------------
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --style=plain --paging=never'
  export BAT_THEME="ansi"   # ikut palette terminal, bukan tema bat terpisah
fi

# --- zoxide ----------------------------------------------------------------
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# --- fzf: Ctrl+R history, Ctrl+T file, Alt+C cd ----------------------------
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
  export FZF_DEFAULT_OPTS="--height=45% --layout=reverse --border=rounded --info=inline --color=bg+:#2a2c31,bg:#1b1c1f,spinner:#8ab4f8,hl:#8ab4f8 --color=fg:#d8dee9,header:#8ab4f8,info:#e0af68,pointer:#8ab4f8 --color=marker:#9ece6a,fg+:#e6e9ef,prompt:#8ab4f8,hl+:#8ab4f8"
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi
fi

# --- Starship --------------------------------------------------------------
# Config utama: ~/.config/starship.toml (symlink ke ~/dotfiles/starship.toml).
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# --- Android SDK (opsional) ------------------------------------------------
if [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
  export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
fi

# --- Plugin zsh ------------------------------------------------------------
# Autosuggestions DULU, syntax-highlighting TERAKHIR.
for plugin in \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
do
  if [ -f "$plugin" ]; then
    source "$plugin"
    break
  fi
done

# Ghost text / suggestion: abu-abu kebiruan, tidak mencolok.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4b5263'
ZSH_AUTOSUGGEST_STRATEGY=(history)

for plugin in \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
do
  if [ -f "$plugin" ]; then
    source "$plugin"
    break
  fi
done

# --- Warna syntax highlighting (graphite) ----------------------------------
typeset -A ZSH_HIGHLIGHT_STYLES

# Perintah & keyword
ZSH_HIGHLIGHT_STYLES[command]='fg=#8ab4f8,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#bb9af7,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[function]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[keyword]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#7dcfff'

# Path, opsi, argumen
ZSH_HIGHLIGHT_STYLES[path]='fg=#9ece6a,underline'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#c9d1d9'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#7d8590'

# Default & error
ZSH_HIGHLIGHT_STYLES[default]='fg=#c9d1d9'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#565f89,italic'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'

# opencode
export PATH=/home/adikhw/.opencode/bin:$PATH
