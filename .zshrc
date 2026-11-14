# --- Setup Bawaan ---
export PATH="$HOME/.local/bin:$PATH"

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

if command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# --- 1. SOURCING PLUGIN (Panggil Pluginnya Dulu) ---
# Cek lokasi plugin & load otomatis (Ubuntu -> home -> oh-my-zsh)
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

# --- 2. DARK SIGNAL COLOR OVERRIDES (Di bawah sourcing plugin) ---
typeset -A ZSH_HIGHLIGHT_STYLES

# Perintah utama (Command) MERAH menyala
ZSH_HIGHLIGHT_STYLES[command]='fg=#ff0000,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ff0000,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#ff0000,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#ff0000,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#ff0000,bold'
ZSH_HIGHLIGHT_STYLES[keyword]='fg=#ff0000,bold'

# Path & Argumen Abu-abu Salju
ZSH_HIGHLIGHT_STYLES[path]='fg=#839294,underline'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#839294'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#839294'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#839294'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#839294'
ZSH_HIGHLIGHT_STYLES[default]='fg=#839294'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ef4444'

# Ghost text / Auto suggestion
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#334155'

if [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_HOME="$HOME/Android/Sdk"
  export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
fi
