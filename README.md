# arch-dotfiles

Kumpulan dotfile zsh yang sudah diadaptasi dari setup Arch Linux untuk dipakai di **WSL Ubuntu**.

## Isi

- `.zshrc` — konfigurasi zsh: prompt starship, plugin autosuggestions & syntax-highlighting, warna "Dark Signal", dan PATH Android SDK (opsional).
- `starship.toml` — tema starship "Dark Signal / Moody Snowscape", copy apa adanya dari Arch.

## Cara pakai di WSL Ubuntu

1. Install paket yang dibutuhkan (lihat daftar di bawah).
2. Copy file ke home:
   ```bash
   cp .zshrc ~/.zshrc
   mkdir -p ~/.config
   cp starship.toml ~/.config/starship.toml
   ```
3. Jadikan zsh shell default (opsional):
   ```bash
   chsh -s "$(command -v zsh)"
   ```
4. Buka terminal baru, lalu cek dengan `exec zsh`.

Semua sourcing dibungkus pengecekan, jadi kalau ada paket yang belum terinstall shell tetap jalan tanpa error. Plugin dicari berurutan di:

1. `/usr/share/zsh-syntax-highlighting/` dan `/usr/share/zsh-autosuggestions/` (paket Ubuntu)
2. `~/.zsh-syntax-highlighting/` dan `~/.zsh-autosuggestions/`
3. `~/.oh-my-zsh/custom/plugins/`

`ANDROID_HOME` hanya di-set kalau folder `~/Android/Sdk` ada.

## Yang perlu diinstall

- `zsh`
- `starship`
- `fastfetch` (opsional, bisa dihapus dari `.zshrc`)
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- **Nerd Font** di sisi Windows (misalnya JetBrainsMono Nerd Font) supaya ikon prompt tampil benar

Contoh di Ubuntu/WSL:

```bash
sudo apt update
sudo apt install zsh starship fastfetch zsh-autosuggestions zsh-syntax-highlighting
```

Kalau `starship` atau `fastfetch` nggak ada di repo Ubuntu, install manual (misalnya lewat cargo atau installer resmi), lalu pastikan `~/.local/bin` ada di PATH — sudah ditambahkan otomatis oleh `.zshrc`.
