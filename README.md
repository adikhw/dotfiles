# dotfiles — adikhw (Fedora)

Konfigurasi shell untuk **bash, zsh, dan sh sekaligus**, dengan satu sumber PATH
supaya `command not found` tidak muncul lagi karena shell yang berbeda.

## Kenapa dulu rusak

Login shell di mesin ini **zsh** (`/usr/bin/zsh`), tapi PATH `~/.npm-global/bin`
( tempat `opencode` ) cuma ada di `~/.bashrc`. Selain itu Spotify dipasang sebagai
**Flatpak**, jadi perintahnya `com.spotify.Client` — bukan `spotify` — dan folder
`/var/lib/flatpak/exports/bin` juga tidak ada di PATH.

Sekarang semua shell membaca file yang sama, jadi tidak bisa drift lagi.

## Isi

| File | Fungsi |
| --- | --- |
| `shell/env.sh` | **Satu-satunya sumber PATH + alias portable.** Edit di sini. |
| `.zshenv` | Dimuat **setiap** zsh (interaktif, script, `zsh -c`). |
| `.zshrc` | Prompt, plugin, warna. Memuat `shell/env.sh`. |
| `.bashrc` | Alias bash, prompt. Memuat `shell/env.sh`. |
| `.bash_profile` | Login bash → memuat `.bashrc`. |
| `.profile` | Login POSIX (`sh`/`dash`) → memuat `shell/env.sh`. |
| `env.d/10-user-path.conf` | PATH sesi desktop/systemd (terminal & app dari GNOME). |
| `doctor.sh` | `shell-doctor` — cek PATH, command, dan wiring config. |
| `install.sh` | Membuat symlink ke `$HOME` (aman dijalankan berulang). |
| `starship.toml` | Prompt starship graphite (satu baris, ikon Nerd Font). |
| `vscode/settings.json` | Tema VS Code "Graphite Tahoe" + font JetBrainsMono NF. |

## Cara pakai

Pasang / sinkronkan setelah clone, atau setiap kali menambah file baru:

```bash
./install.sh
exec zsh          # atau buka terminal baru
shell-doctor      # semua harus "ok"
```

`install.sh` memindahkan file lama ke `~/.dotfiles-backup-<timestamp>/`, lalu
membuat symlink. Artinya `~/.zshrc` **adalah** `~/dotfiles/.zshrc` — edit salah
satunya sama saja, dan `git status` langsung terlihat.

Setelah mengubah PATH, logout/login sekali supaya sesi GNOME ikut memakai PATH
baru (`env.d/10-user-path.conf` dibaca saat login).

## VS Code

`install.sh` juga menyymlink `vscode/settings.json` ke
`~/.config/Code/User/settings.json`, jadi setting VS Code ikut ke-track git dan
sama di semua mesin.

Isinya:

- Base theme bawaan **Dark Modern** (tanpa extension tema, jadi tidak bisa
  fallback ke theme yang tidak terpasang).
- `workbench.colorCustomizations` disamakan dengan palette terminal
  `graphite-tahoe`: background `#1b1c1f`, panel `#232529`, aksen `#8ab4f8`.
- Token warna editor + semantic token (comment, keyword, string, number, dsb).
- Font editor/terminal `JetBrainsMono Nerd Font` (fallback ke JetBrains Mono
  atau monospace kalau belum terpasang).

Tidak ada setting yang bergantung pada extension, kecuali
`workbench.iconTheme: material-icon-theme` yang otomatis fallback ke ikon
bawaan kalau extension-nya belum ada.

## Menambah tool baru

Kalau binary-nya masuk ke salah satu folder ini, tidak perlu ngapa-ngapain:

```
~/.local/bin            ~/.cargo/bin
~/.npm-global/bin       ~/go/bin
/var/lib/flatpak/exports/bin  ~/.local/share/flatpak/exports/bin
```

Kalau folder baru (misal `~/.bun/bin`), tambahkan ke `_envsh_user_dirs` di
`shell/env.sh`, jalankan `./install.sh`, lalu `shell-doctor`.

## Yang perlu diinstall

`zsh`, `starship`, `fastfetch`, `eza`, `bat`, `neovim`,
`zsh-autosuggestions`, `zsh-syntax-highlighting`, `flatpak`, dan Nerd Font
(JetBrainsMono Nerd Font) supaya ikon prompt tampil.

```bash
sudo dnf install zsh starship fastfetch eza bat neovim \
    zsh-autosuggestions zsh-syntax-highlighting flatpak
```
