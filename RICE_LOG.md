# RICE_LOG — Fedora GNOME → macOS Tahoe

Dibuat: 17 November 2026
Mesin: `fedora` / user `adikhw` / sesi **Wayland** / GNOME Shell **51.1** (GDM 51.1.1) / Fedora **45**
Resolusi: 1920x1080 (eDP-1)

> Catatan umum: semua perubahan ada di level **user** (dconf/gsettings, `~/.themes`, `~/.local/share/icons`, `~/.config/gtk-4.0`, `~/.config/mozilla`, `~/.local/share/gnome-shell/extensions`) **kecuali** Tahap 8 (GDM) yang memang butuh root dan sudah dikonfirmasi.

---

## 1. Paket yang dipasang

| Paket | Versi | Keterangan |
|---|---|---|
| `sassc` (+ `libsass`) | 3.6.2 / 3.6.6 | build tema GTK/Shell |
| `glib2-devel` | 2.90.1 | `glib-compile-resources` |
| `gtk-murrine-engine` | 0.98.2 | engine GTK2 (jaga-jaga, tidak dipakai GNOME 51) |
| `rsms-inter-fonts` | 4.1 | font **Inter** (resmi rsms) |

Sudah ada sebelumnya (tidak diinstall ulang): `gnome-tweaks 49.0`, Extension Manager Flatpak `0.7.0`, Dash to Dock `110` (dnf), `JetBrainsMono Nerd Font` (di `~/.local/share/fonts`), `git`, `flatpak 1.18.4`, ImageMagick 7.1.2, Ptyxis 50.1, Firefox 160.0 (RPM).

Install paket: `sudo dnf install -y sassc glib2-devel gtk-murrine-engine rsms-inter-fonts`

## 2. Extension (semua dari extensions.gnome.org, versi cocok GNOME 51)

| Extension | Versi | shell-version |
|---|---|---|
| User Themes (`user-theme@gnome-shell-extensions.gcampax.github.com`) | 78 | 51 |
| Blur my Shell (`blur-my-shell@aunetx`) | 78 | 46–51 |
| Rounded Window Corners Reborn (`rounded-window-corners@fxgn`) | 26 | 51 |
| Animation Tune (`anim-tune@adikhw.local`) | 1 | 51 — **buatan sendiri**, 15 baris, set `St.Settings.slow_down_factor = 0.8` |

Install: `gnome-extensions install --force <file>.zip` lalu
`gsettings set org.gnome.shell enabled-extensions "['background-logo@fedorahosted.org','dash-to-dock@micxgx.gmail.com','user-theme@gnome-shell-extensions.gcampax.github.com','blur-my-shell@aunetx','rounded-window-corners@fxgn','anim-tune@adikhw.local']"`

Tidak diaktifkan: `no-overview@fthx` (Super sendirian sudah dimatikan lewat `overlay-key=''`).

## 3. Tema, ikon, kursor, font

- **GTK + Shell**: `WhiteSur-Dark-solid-grey` (WhiteSur-gtk-theme, commit `d578265`, Sep 2026)
  - Build: `./install.sh -c dark -t grey -o solid --shell --round --libadwaita`
  - `~/.themes/WhiteSur-Dark-solid-grey` (+ `-hdpi`, `-xhdpi`)
  - libadwaita/GTK4: `~/.config/gtk-4.0/gtk.css -> gtk-Dark.css` (dari opsi `--libadwaita`)
- **Ikon**: `MacTahoe-grey-dark` — **MacTahoe-icon-theme** (vinceliuice, tema ikon resmi gaya macOS Tahoe). Bukan WhiteSur icon, karena sudah ada paket yang khusus Tahoe.
  - `./install.sh -t grey` → `MacTahoe-grey`, `-grey-light`, `-grey-dark` di `~/.local/share/icons`
- **Kursor**: `WhiteSur-cursors` (putih bulat, prebuilt `dist/`), size 24
- **Font**: `Inter 11` (interface + document), mono `JetBrainsMono Nerd Font 11`

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Dark-solid-grey'
gsettings set org.gnome.desktop.wm.preferences theme 'WhiteSur-Dark-solid-grey'
gsettings set org.gnome.desktop.interface icon-theme 'MacTahoe-grey-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
gsettings set org.gnome.desktop.interface cursor-size 24
gsettings set org.gnome.desktop.interface font-name 'Inter 11'
gsettings set org.gnome.desktop.interface document-font-name 'Inter 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'slate'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
GSETTINGS_SCHEMA_DIR=~/.local/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com/schemas \
  gsettings set org.gnome.shell.extensions.user-theme name 'WhiteSur-Dark-solid-grey'
```

Tombol window: **kiri**, urutan kiri→kanan **merah (close), kuning (minimize), hijau (maximize)** — persis *traffic lights* macOS. (Diubah 19 Nov 2026; sebelumnya sempat di kanan dengan urutan hijau-kuning-merah.)

## 4. Blur / Glass (Blur my Shell 78)

Schema: `org.gnome.shell.extensions.blur-my-shell.*` (butuh `GSETTINGS_SCHEMA_DIR` ke folder `schemas` extension kalau dijalankan dari CLI sebelum extension aktif).

| Bagian | Setting |
|---|---|
| panel | `blur=true`, `static-blur=true`, `override-background=true`, `style-panel=0` (transparent), `brightness=0.45`, `sigma=45`, `corner-radius=0`, `unblur-in-overview=false` |
| dash-to-dock | `blur=true`, `static-blur=true`, `override-background=true`, `style-dash-to-dock=0` (transparent), `brightness=0.45`, `sigma=45` |
| overview | `blur=true`, `style-components=3` (transparent), `workspace-corner-radius=24` |
| appfolder | `blur=true`, `blur-behind-folders=true`, `sigma=45`, `brightness=0.45` |
| popup | `blur=true`, `style-popup=2` (dark), `override-background=true`, blur calendar/quick-settings/menus/notifications/dialogs/submenus ON, radius: menu 14, quick-settings 28, calendar 24, notif 16, dialog 18, OSD 26 |
| applications | `blur=true`, `whitelist=['org.gnome.Ptyxis','Ptyxis']`, `corner-radius=18`, `dynamic-opacity=true`, `blur-menus=false` |

Catatan: **tidak ada persentase** di Blur my Shell. Knob-nya `sigma` (kekuatan blur) dan `brightness` (gelap/terang lapisan). Nilai sekarang: sigma 45 (default 30), brightness 0.45.

## 5. Dock (Dash to Dock 110)

```bash
D=org.gnome.shell.extensions.dash-to-dock
gsettings set $D dock-position 'BOTTOM'
gsettings set $D extend-height false
gsettings set $D dock-fixed false
gsettings set $D autohide true
gsettings set $D intellihide true
gsettings set $D intellihide-mode 'ALL_WINDOWS'
gsettings set $D custom-theme-shrink true      # pill mengambang di tengah
gsettings set $D always-center-icons true
gsettings set $D dash-max-icon-size 40
gsettings set $D show-show-apps-button false
gsettings set $D show-mounts false
gsettings set $D height-fraction 0.9
gsettings set $D animation-time 0.15
gsettings set $D hide-delay 0.15
gsettings set $D show-delay 0.15
```

Perilaku: **sembunyi kalau ada window** (permintaan user), muncul lagi saat desktop bersih.

CSS tambahan di akhir `~/.themes/WhiteSur-Dark-solid-grey/gnome-shell/gnome-shell.css`:

```css
/* ===== RICE CUSTOM: floating dock ala Tahoe ===== */
#dashtodockContainer.bottom #dash .dash-background,
#dashtodockContainer.bottom.shrink #dash .dash-background {
  border-radius: 22px;
  margin-bottom: 8px;
}
#dashtodockContainer.bottom #dash .dash-separator { margin-bottom: 2px; }
```

Backup CSS asli: `~/rice-backup/gnome-shell.css.orig`

## 6. Rounded window + shadow (Rounded Window Corners Reborn 26)

```
borderRadius = 18
padding = 1 (semua sisi)
smoothing = 0
borderColor = [0.45,0.45,0.48,0.6]
border-width = 0
keepRoundedCorners.maximized/fullscreen = false
skip-libadwaita-app = false
focused-shadow   : offset-y 6, blur 40, spread 0,  opacity 35
unfocused-shadow : offset-y 3, blur 24, spread -2, opacity 30
```

## 7. Animasi (Tahap 4)

Extension `anim-tune@adikhw.local` → `slow_down_factor = 0.8` (durasi animasi 80% = 20% lebih cepat), animasi **tetap aktif** (`enable-animations=true`).
Aktif setelah **logout/login**.

## 8. Terminal (Ptyxis 50.1)

```bash
gsettings set org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/423ef435b892dc584820fb186afb2270/ opacity 0.8
gsettings set org.gnome.Ptyxis use-system-font false
gsettings set org.gnome.Ptyxis font-name 'JetBrainsMono Nerd Font 11'
```
Blur terminal: whitelist `applications` Blur my Shell (`org.gnome.Ptyxis`, `Ptyxis`) + corner-radius 18.
Font JetBrains Mono Nerd Font sudah terpasang sebelumnya di `~/.local/share/fonts/JetBrainsMono`.

## 9. Wallpaper (Tahap 6)

- Generator: `~/Pictures/Wallpapers/generate_tahoe_wallpaper.py` (Pillow, murni kode sendiri: gradasi gelap + pita ombak teal/indigo/violet + grain + vignette, supersample 2x)
- Hasil: `~/Pictures/Wallpapers/tahoe-dark.png` (1920x1080)
- Dipasang:

```bash
gsettings set org.gnome.desktop.background picture-uri 'file:///home/adikhw/Pictures/Wallpapers/tahoe-dark.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/adikhw/Pictures/Wallpapers/tahoe-dark.png'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/adikhw/Pictures/Wallpapers/tahoe-dark.png'
gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
```

Buat GDM: copy ke `/usr/share/backgrounds/rice/tahoe-dark.png`.

## 10. Flatpak & Firefox (Tahap 7)

**Flatpak** (global + Spotify):
```bash
flatpak override --user --filesystem=~/.themes:ro --filesystem=~/.icons:ro \
  --filesystem=~/.local/share/themes:ro --filesystem=~/.local/share/icons:ro \
  --filesystem=xdg-config/gtk-3.0:ro --filesystem=xdg-config/gtk-4.0:ro \
  --env=GTK_THEME=WhiteSur-Dark-solid-grey
flatpak override --user com.spotify.Client ... (setting sama)
```

**Firefox** (WhiteSur-firefox-theme, repo resmi, commit `ecc6465`):
- Tema di `~/.mozilla/firefox/firefox-themes` (hasil `./install.sh` tanpa sudo)
- Profil Fedora 45 ada di `~/.config/mozilla/firefox` (XDG), jadi di-link manual:
  `~/.config/mozilla/firefox/nyzltc9t.default-release/chrome -> ~/.mozilla/firefox/firefox-themes`
- `user.js` prefs:
  ```
  toolkit.legacyUserProfileCustomizations.stylesheets = true
  browser.tabs.drawInTitlebar = true
  browser.uidensity = 0
  layers.acceleration.force-enabled = true
  mozilla.widget.use-argb-visuals = true
  widget.gtk.rounded-bottom-corners.enabled = true
  svg.context-properties.content.enabled = true
  browser.startup.page = 3
  browser.sessionstore.resume_from_crash = true
  browser.newtabpage.pinned = []
  browser.newtabpage.activity-stream.showSponsored = false
  browser.newtabpage.activity-stream.showSponsoredTopSites = false
  ```
- Catatan: Fedora memaksa homepage default `https://start.fedoraproject.org/` dari
  `/usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js`.
  Kita **tidak** edit file sistem; `user.js` menimpa dengan `about:home`.
- Pernah kejadian: profil kosong `oa81bw0q.default` terpilih sebagai default → Firefox tampak mulai dari awal + buka start page Fedora. Sudah dibenerin: `profiles.ini`/`installs.ini` dikunci ke `nyzltc9t.default-release`.

## 11. Lock screen & GDM (Tahap 8)

**Lock screen**: ikut shell theme (User Themes) + `org.gnome.desktop.screensaver picture-uri` (wallpaper yang sama).

**GDM — Opsi 1 (dipilih, dconf saja):**
| File | Isi |
|---|---|
| `/usr/share/backgrounds/rice/tahoe-dark.png` | wallpaper (644) |
| `/etc/dconf/db/gdm.d/00-rice` | wallpaper + zoom + `color-scheme=prefer-dark` untuk GDM |
| `/etc/dconf/profile/gdm` | dibuat dari `/usr/share/dconf/profile/gdm` (sebelumnya tidak ada) |
| `/etc/dconf/db/gdm` | hasil `dconf update` (db biner) |

Verifikasi: sebagai user `gdm`, `picture-uri-dark` = `file:///usr/share/backgrounds/rice/tahoe-dark.png`, `color-scheme=prefer-dark`.
Dialog login tetap **Adwaita bawaan** (tidak ada gresource yang diganti) → aman.

## 12. Yang tidak bisa dicapai persis + pendekatan pengganti

1. **WhiteSur shell theme resmi cuma support CSS sampai GNOME 48.** GNOME 51.1 masih jalan (dicek: tidak ada error CSS/journal, 68 class baru GNOME 51 yang belum ke-style — mayoritas elemen login/GDM/label kecil, kosmetik). Alternatif kalau suatu saat rusak: matikan User Themes, pakai Adwaita + Blur my Shell.
2. **"Blur dalam persen"** tidak ada di Blur my Shell → dipakai `sigma` (kekuatan) + `brightness` (gelap).
3. **Spotify/VS Code (Electron)** tidak bisa ikut tema GTK penuh; hanya ikut dark mode via portal. libadwaita apps ikut lewat `~/.config/gtk-4.0`.
4. **GDM full theme** (opsi 2) tidak dipakai: butuh mengganti `/usr/share/gnome-shell/gnome-shell-theme.gresource`, berisiko di GNOME 51 (tema built for 48) dan bisa bikin GDM gagal start.
5. **Windows app blur** hanya untuk app yang di-whitelist di Blur my Shell (sekarang terminal). Blur jendela app lain belum diaktifkan (biar tidak berat).
6. Dock sekarang **auto-hide saat ada window** (permintaan user), bukan selalu tampil.
7. Tombol window sekarang di **kiri** dengan urutan merah-kuning-hijau (macOS traffic lights), diubah 19 Nov 2026 — kompromi awal (kanan, hijau-kuning-merah) sudah dibatalkan.

## 13. Backup & cara restore

Backup awal:
- `~/dconf-backup-before-rice.conf` (semua dconf sebelum rice)
- `~/rice-backup/gtk-3.0`, `~/rice-backup/gtk-4.0`
- `~/rice-backup/gnome-shell.css.orig` (shell theme sebelum CSS dock ditambahkan)
- `~/rice-backup/firefox/` (profiles.ini, installs.ini, user.js, sessionstore lama)
- `~/rice-backup/gdm/gdm.db.bak` (db dconf GDM sebelum perubahan)

Restore:
```bash
# 1) dconf (keybinding, workspace, dock, gsettings, dll)
dconf load / < ~/dconf-backup-before-rice.conf

# 2) GTK config
cp -a ~/rice-backup/gtk-3.0/. ~/.config/gtk-3.0/
cp -a ~/rice-backup/gtk-4.0/. ~/.config/gtk-4.0/

# 3) CSS shell theme (buang tweak dock)
cp ~/rice-backup/gnome-shell.css.orig ~/.themes/WhiteSur-Dark-solid-grey/gnome-shell/gnome-shell.css

# 4) Firefox
cp ~/rice-backup/firefox/profiles.ini ~/.config/mozilla/firefox/
cp ~/rice-backup/firefox/installs.ini ~/.config/mozilla/firefox/
# hapus tema: rm ~/.config/mozilla/firefox/*/chrome && hapus baris toolkit.legacy... di user.js

# 5) GDM (root)
sudo rm -f /etc/dconf/db/gdm.d/00-rice
sudo dconf update
# opsional: sudo rm /etc/dconf/profile/gdm ; sudo rm -rf /usr/share/backgrounds/rice
# kalau db GDM mau dikembalikan persis: sudo cp ~/rice-backup/gdm/gdm.db.bak /etc/dconf/db/gdm

# 6) Extension: nonaktifkan/ Hapus
gsettings set org.gnome.shell enabled-extensions "['background-logo@fedorahosted.org','dash-to-dock@micxgx.gmail.com']"
```

Kalau layar login bermasalah: `Ctrl+Alt+F3` → login TTY → jalankan restore GDM di atas → `Ctrl+Alt+F1`.

## 14. Verifikasi akhir (sudah dicek)

- 52 keybinding/workspace dibandingkan dengan backup → **0 berbeda**
  - `close=['<Alt>F4','<Super>q']`, `minimize=['<Super><Shift>h']`, `toggle-maximized=['<Alt>F10','<Super>v']`, dll.
  - `Super+1..9` → switch workspace, `Super+Shift+1..9` → move window
  - `Super+Enter` → `ptyxis --new-window`, `Super+F` → firefox, `Super+E` → nautilus, `Super+Shift+Q` → logout
  - `overlay-key=''` → Super sendirian tetap **tidak** buka Overview
  - `dynamic-workspaces=false`, `num-workspaces=9`
- Extension aktif: rounded-window-corners, user-theme, blur-my-shell, background-logo, dash-to-dock → semua **ACTIVE**
- `journalctl` bersih: tidak ada error `invalidate_notifier`, tidak ada JS ERROR dari extension
- `gnome-extensions list --enabled` sesuai target

## 15. Sisa langkah

- **Logout/reboot** untuk: load `anim-tune` (animasi dipercepat), melihat layar login GDM baru, dan test lock screen (`Super+Shift+L`).

## Addon 2026-11-17: Tahoe Rice & Final Polish

### Packages & Tools Installed
- **Ulauncher**: v5.16.3 (from Fedora repo), systemd service enabled, bound to `Super+Space`, custom `graphite-tahoe` theme.
- **CLI Utilities**: `eza` (icons, git status), `bat`, `zoxide`, `fzf`, `grim`, `slurp`, `wl-clipboard`, `fastfetch` (v2.68.1).
- **Shell**: Full rewrite of `~/.zshrc` (100k history, autosuggestions, graphite syntax highlighting, eza/bat/zoxide/fzf integration) and `~/.config/starship.toml` (one-line graphite prompt with Nerd Font icon spacing fix).
- **Ptyxis Terminal**: Palette set to `graphite-tahoe`.
- **GNOME Shell Extensions**:
  - `window-title-pro@eprahemi.github.io` (v15) — app name + icon on the left top bar.
  - `clipboard-indicator@tudmotu.com` (v74) — clipboard history via `Super+Shift+V` (size 30).
  - `dock-hover@adikhw.local` (custom) — macOS-style magnification/lift animation on Dash to Dock icon hover using Clutter `ease()`.
  - `anim-tune@adikhw.local` (custom) — slight speed boost (`slow_down_factor = 0.8`).
- **Fastfetch**: Custom config at `~/.config/fastfetch/config.jsonc` with built-in Tux ASCII logo and clean module list.

### Keybinding Changes & Shortcuts Preserved
- **Freed**: `Super+Space` (Ulauncher), `Super+Shift+V` (Clipboard history, freed from `toggle-message-tray`), `Ctrl+Super+3/4` (Screenshots, freed from app slots 3/4).
- **Custom Shortcuts Added**:
  - `Super+Space`: Ulauncher toggle
  - `Super+Shift+V`: Clipboard indicator history menu
  - `Ctrl+Super+3`: Full screenshot (`~/.local/bin/screenshot-tahoe full`) + clipboard copy
  - `Ctrl+Super+4`: Area screenshot (`~/.local/bin/screenshot-tahoe area`) + clipboard copy
- **Original Shortcuts Untouched**:
  - `Super+Enter` (Terminal/Ptyxis)
  - `Super+F` (Files)
  - `Super+Q` (Close window)
  - `Super+E` (Editor)
  - `Super+V` (Toggle maximized)
  - `Super+M` (Maximize)
  - `Super+D` (Show desktop)
  - `Super+1..9` / `Super+Shift+1..9` (Workspaces)
  - `Super` sendirian tetap kosong (`overlay-key=''`) untuk menghindarioverview tak sengaja.

### Config Files & Locations
- Zsh: `~/dotfiles/.zshrc` (symlinked to `~/.zshrc`)
- Starship: `~/dotfiles/starship.toml` (symlinked to `~/.config/starship.toml`)
- Ptyxis Palette: `~/.local/share/org.gnome.Ptyxis/palettes/graphite-tahoe.palette`
- Ulauncher Theme: `~/.config/ulauncher/user-themes/graphite-tahoe/`
- Screenshot Helper: `~/.local/bin/screenshot-tahoe`
- Fastfetch Config: `~/.config/fastfetch/config.jsonc`
- Custom Extensions:
  - `~/.local/share/gnome-shell/extensions/dock-hover@adikhw.local/`
  - `~/.local/share/gnome-shell/extensions/anim-tune@adikhw.local/`

### Restore Instructions
- Dotfiles git commit: `4f0d506` (`~/dotfiles`).
- Backup dconf: `~/dconf-backup-before-addon.conf`.
- Shell backup: `~/rice-backup/addon-2026-11-17/`.

### VS Code (Electron) — Graphite Tahoe
Electron tidak bisa ikut tema GTK penuh (lihat catatan kompromi #3), jadi disamakan manual.
- Config: **`~/dotfiles/vscode/settings.json`** (symlink dari `~/.config/Code/User/settings.json`), commit `78ede27`
- Base theme: `Dark Modern` (built-in VS Code 1.146, tidak butuh extension — "Catpuccin Mocha Transparent" ternyata sudah tidak terpasang)
- `workbench.colorCustomizations`: 129 warna, background `#1b1c1f`, panel `#232529`, aksen `#8ab4f8`, border `#3b4252`, plus palette terminal graphite-tahoe lengkap (ANSI 0–15)
- `editor.tokenColorCustomizations` + `editor.semanticTokenColorCustomizations`: comment `#565f89` italic, keyword `#bb9af7`, string `#9ece6a`, number/type `#e0af68`, function/type `#7dcfff`, tag `#f7768e`
- Font editor & terminal: `JetBrainsMono Nerd Font` (ligatures aktif, terminal size 13), UI tetap ikut font sistem Inter 11
- Backup sebelum diubah: `~/rice-backup/addon-2026-11-17/Code-settings.before-graphite.json`
- Pindah mesin/laptop: clone `~/dotfiles` lalu jalankan `./install.sh` — symlink VS Code dibuat otomatis.

## Addon 2026-11-19: macOS traffic lights (merah-kuning-hijau)

Tombol window diubah ke posisi dan urutan macOS asli:

```bash
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
```

- **Posisi**: kiri (sebelumnya kanan).
- **Urutan kiri→kanan**: merah `close` → kuning `minimize` → hijau `maximize`.
- **Tanpa CSS baru**: tema `WhiteSur-Dark-solid-grey` sudah memakai aset PNG *traffic light* —
  close `#E9524A`, minimize `#F1AE1B`, maximize `#59C837` — di
  `~/.themes/WhiteSur-Dark-solid-grey/gtk-3.0/windows-assets/` dan `gtk-4.0/windows-assets/`
  (libadwaita memakai salinan di `~/.config/gtk-4.0/windows-assets/`).
  `button-layout` hanya mengatur sisi & urutan, jadi perubahan langsung aktif tanpa logout.
- **Berlaku di**: app GTK CSD (Nautilus, Ptyxis, GNOME Settings, dll), termasuk app libadwaita
  lewat `~/.config/gtk-4.0/gtk.css`.
- **Tidak berlaku di**: Firefox (titlebar digambar sendiri; `browser.tabs.drawInTitlebar=true`),
  VS Code/Electron/Spotify (titlebar custom), dan app X11/legacy.
- **Restore ke kompromi lama** (kanan, hijau-kuning-merah):
  `gsettings set org.gnome.desktop.wm.preferences button-layout ':maximize,minimize,close'`
- Log ini disalin ke `~/dotfiles/RICE_LOG.md` dan di-commit di repo dotfiles.
