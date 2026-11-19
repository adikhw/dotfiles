# KEYBINDINGS.md — GNOME 51 ala Hyprland

Setup keyboard-driven di Fedora Workstation, tanpa ganti tema/ikon/wallpaper.

## Lingkungan

| Item | Nilai |
|---|---|
| OS | Fedora Linux 45 (Workstation) |
| Desktop | GNOME Shell 51.1, Wayland |
| Terminal | Ptyxis 50.1 (`/usr/bin/ptyxis`) |
| File manager | Nautilus 51.1 |
| Browser | Firefox 160.0 |
| Dock | Dash to Dock 110 (repo Fedora, metadata support GNOME 45–51) |

---

## 1. Backup & cara restore

Backup dibuat **sebelum** ada perubahan:

```
~/dconf-backup-before.conf
```

### Restore total (kembali persis ke kondisi awal)

```bash
dconf reset -f /
dconf load / < ~/dconf-backup-before.conf
```

> `dconf reset -f /` menghapus **semua** setting dconf user (termasuk setting aplikasi lain yang dibuat setelah backup), lalu file backup dimuat ulang. Logout/login setelah restore biar semua aplikasi baca ulang.

### Restore satu setting saja (tanpa sentuh yang lain)

```bash
# balikin ke default GNOME
gsettings reset org.gnome.desktop.interface enable-hot-corners

# atau set manual ke nilai lama, contoh:
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l']"
```

Cek isi backup kapan saja:

```bash
grep -n "enable-hot-corners\|dynamic-workspaces\|num-workspaces" ~/dconf-backup-before.conf
```

---

## 2. Daftar keybinding aktif

### Window & aplikasi

| Shortcut | Fungsi | Catatan |
|---|---|---|
| `Super+Enter` | Buka terminal (Ptyxis, window baru) | custom keybinding |
| `Super+F` | Buka Firefox | custom keybinding |
| `Super+E` | Buka file manager (Nautilus, window baru) | custom keybinding |
| `Super+Q` | Tutup window/app aktif | native `close` |
| `Super+V` | Toggle maximize (pengganti "floating") | native `toggle-maximized` |
| `Super+M` | Fullscreen | native `toggle-fullscreen` |
| `Super+Shift+Q` | Logout **dengan dialog konfirmasi** | `gnome-session-quit --logout` |

> GNOME/Mutter nggak punya konsep "floating window" seperti Hyprland. `Super+V` jadi toggle maximize/unmaximize. `Alt+F10` juga tetap berfungsi.

### Workspace (fixed 9)

| Shortcut | Fungsi |
|---|---|
| `Super+1` … `Super+9` | Pindah ke workspace 1–9 |
| `Super+Shift+1` … `Super+Shift+9` | Bawa window aktif ke workspace 1–9 |

Dynamic workspaces dimatikan, jadi jumlahnya tetap 9.

### Pindah fokus window

GNOME nggak punya directional focus native, jadi dipakai **window cycling**:

| Shortcut | Fungsi |
|---|---|
| `Super+Right`, `Super+Down`, `Super+J`, `Super+L` | Window berikutnya |
| `Super+Left`, `Super+Up`, `Super+H`, `Super+K` | Window sebelumnya |

### Shortcut bawaan yang dipindah (karena bentrok)

| Shortcut lama | Fungsi | Sekarang |
|---|---|---|
| `Super+V` / `Super+M` | Notification tray | `Super+Shift+V` |
| `Super+H` | Minimize window | `Super+Shift+H` |
| `Super+L` | Lock screen | `Super+Shift+L` |
| `Super+Up` / `Super+Down` | Maximize / unmaximize | dilepas (pakai `Super+V`) |
| `Super+1..9` | Buka app ke-1..9 di dock | dilepas → jadi workspace switcher |
| `Super+Q` (internal Dash to Dock) | Shortcut dock | dikosongkan |
| `Super+1..9` (internal Dash to Dock hotkeys) | App hotkeys dock | dimatikan (`hot-keys=false`) |

Yang tetap seperti bawaan: `Super` (tap) = Overview, `Super+A` = app grid, `Super+Tab` = switch app, `Alt+Tab` = switch window, `Super+L` sekarang fokus kanan jadi lock pindah ke `Super+Shift+L`.

---

## 3. Setting yang diubah (semua via gsettings/dconf)

### Hilangkan gangguan

```bash
gsettings set org.gnome.desktop.interface enable-hot-corners false
for i in 1 2 3 4 5 6 7 8 9; do
  gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
done
```

### Workspace

```bash
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 9
for i in 1 2 3 4 5 6 7 8 9; do
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
  gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
done
```

### Window control

```bash
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super>q']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt>F10', '<Super>v']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings maximize "[]"
gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Alt>F5']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super><Shift>l']"
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super><Shift>v']"
```

### Fokus window (cycle)

```bash
gsettings set org.gnome.desktop.wm.keybindings switch-windows \
  "['<Super>Right', '<Super>Down', '<Super>j', '<Super>l']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward \
  "['<Super>Left', '<Super>Up', '<Super>h', '<Super>k']"
```

### Custom keybindings (terminal, browser, files, logout)

```bash
BASE=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['$BASE/custom0/', '$BASE/custom1/', '$BASE/custom2/', '$BASE/custom3/']"

# custom0 = terminal
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom0/ name 'Terminal (Ptyxis)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom0/ command 'ptyxis --new-window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom0/ binding '<Super>Return'

# custom1 = firefox
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom1/ name 'Firefox'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom1/ command 'firefox'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom1/ binding '<Super>f'

# custom2 = file manager
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom2/ name 'File Manager (Nautilus)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom2/ command 'nautilus --new-window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom2/ binding '<Super>e'

# custom3 = logout dengan konfirmasi
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom3/ name 'Logout (konfirmasi)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom3/ command 'gnome-session-quit --logout'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$BASE/custom3/ binding '<Super><Shift>q'
```

### Dash to Dock (dock selalu muncul di bawah)

```bash
S=org.gnome.shell.extensions.dash-to-dock
gsettings set $S dock-position "'BOTTOM'"
gsettings set $S dock-fixed false      # lihat section 8 (mode intellihide)
gsettings set $S autohide true
gsettings set $S intellihide true
gsettings set $S intellihide-mode "'ALL_WINDOWS'"
gsettings set $S extend-height false
gsettings set $S dash-max-icon-size 40
gsettings set $S show-show-apps-button false
gsettings set $S always-center-icons true
gsettings set $S animation-time 0.15
gsettings set $S hot-keys false        # jangan rebut Super+1..9
gsettings set $S shortcut "[]"          # jangan rebut Super+Q
gsettings set org.gnome.shell enabled-extensions \
  "['background-logo@fedorahosted.org', 'dash-to-dock@micxgx.gmail.com', 'no-overview@fthx']"
```

Dock bawaan GNOME (yang cuma muncul di Overview) otomatis digantikan oleh Dash to Dock saat extension aktif — nggak perlu dimatikan manual. Kalau extension gagal load, dash overview kembali normal dan itu bukan konflik setting.

---

## 4. Paket yang dipasang

```bash
sudo dnf install -y gnome-tweaks gnome-extensions-app gnome-shell-extension-dash-to-dock
sudo flatpak install -y flathub com.mattjakeman.ExtensionManager
```

- `gnome-shell-extension-dash-to-dock` 110-1.fc45 (support GNOME 45–51 ✓)
- `com.mattjakeman.ExtensionManager` 0.7.0 (Flatpak Flathub) untuk cari/update extension lain

Uninstall kalau perlu:

```bash
sudo dnf remove gnome-shell-extension-dash-to-dock gnome-extensions-app
sudo flatpak uninstall com.mattjakeman.ExtensionManager
```

---

## 5. Apa yang baru aktif setelah logout/login

| Setting | Kapan aktif |
|---|---|
| Hot corner, keybinding, workspace, custom shortcut | **langsung** (kadang Overview baru refresh setelah ditutup-buka) |
| **Dash to Dock + semua setting dock** | **setelah logout/login** |

Alasannya: extension di-install saat GNOME Shell sudah jalan ±9 jam, dan GNOME 51 nggak me-rescan folder extension sistem secara live. Metadata versinya sudah cocok (45–51), jadi cuma butuh reload session — bukan mismatch versi.

Setelah login, cek:

```bash
gnome-extensions list --enabled
gnome-extensions info dash-to-dock@micxgx.gmail.com
```

Kalau dock belum muncul juga, cek error:

```bash
journalctl --user -b | grep -i -E "dash|extension"
```

Matikan sementara kalau bermasalah:

```bash
gnome-extensions disable dash-to-dock@micxgx.gmail.com
```

---

## 6. Verifikasi cepat

```bash
# hot corner & workspace
gsettings get org.gnome.desktop.interface enable-hot-corners     # false
gsettings get org.gnome.mutter dynamic-workspaces                # false
gsettings get org.gnome.desktop.wm.preferences num-workspaces     # 9

# shortcut inti
gsettings get org.gnome.desktop.wm.keybindings close
gsettings get org.gnome.desktop.wm.keybindings toggle-maximized
gsettings get org.gnome.desktop.wm.keybindings toggle-fullscreen
gsettings get org.gnome.desktop.wm.keybindings switch-windows
gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-4
gsettings get org.gnome.desktop.wm.keybindings move-to-workspace-4

# custom keybindings
gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings

# dock
gsettings get org.gnome.shell.extensions.dash-to-dock autohide
gsettings get org.gnome.shell.extensions.dash-to-dock dock-position
gsettings get org.gnome.shell.extensions.dash-to-dock show-show-apps-button
gsettings get org.gnome.shell enabled-extensions
```

Scan bentrok otomatis (0 duplikat saat setup ini dibuat):

```bash
python3 /tmp/opencode/check-keys.py
```

---

## 7. Catatan / limitasi

1. **Nggak ada floating window** di Mutter. `Super+V` = toggle maximize.
2. **Directional focus nggak native** — dipakai window cycling (`switch-windows`), jadi `Super+Right/Down/J/L` = window berikutnya, `Super+Left/Up/H/K` = sebelumnya.
3. Tema/ikon/wallpaper **tidak disentuh** (tetap Adwaita / default Fedora).
4. Dash to Dock mode dock menggantikan dash di Overview; ikon dock tetap sinkron dengan favorit GNOME.
5. Backup awal: `~/dconf-backup-before.conf` — jangan dihapus sebelum yakin nyaman.

---

## 8. Mode desktop biasa (bukan Overview)

Tujuan: desktop normal, dock muncul saat desktop kosong tapi ngumpet kalau ada window (biar window nggak kepotong), Super cuma jadi modifier, login langsung ke desktop.

### Backup

```
~/dconf-backup-before-desktop.conf     # sebelum perubahan mode desktop
~/dconf-backup-before-intellihide.conf # sebelum dock diubah ke intellihide
```

Restore total (kembalikan kondisi sebelum perubahan bagian ini):

```bash
dconf reset -f /
dconf load / < ~/dconf-backup-before-desktop.conf
```

### Perubahan

| Hal | Setting | Nilai |
|---|---|---|
| Super sendiri nggak buka Overview | `org.gnome.mutter overlay-key` | `''` |
| Mode dock | `dash-to-dock dock-fixed` | `false` |
| Sembunyi saat ada window overlap | `intellihide` / `intellihide-mode` | `true` / `ALL_WINDOWS` |
| Bisa muncul saat hover di bawah | `autohide` | `true` |
| Tidak pernah hide manual | `manualhide` | `false` |
| Posisi & ukuran | `dock-position` / `dash-max-icon-size` | `BOTTOM` / `40` |
| Delay show/hide | `hide-delay` / `show-delay` | `0.15` / `0.15` |
| Tombol Show Apps | `show-show-apps-button` | `false` |
| Shortcut internal D2D | `hot-keys` / `shortcut` | `false` / `[]` |
| Launcher | `org.gnome.shell.keybindings toggle-application-view` | `['<Super>a', '<Super>d']` |
| Login langsung desktop | extension `no-overview@fthx` | enabled |

Command lengkap:

```bash
gsettings set org.gnome.mutter overlay-key ''

S=org.gnome.shell.extensions.dash-to-dock
gsettings set $S dock-fixed false
gsettings set $S intellihide true
gsettings set $S intellihide-mode "'ALL_WINDOWS'"
gsettings set $S autohide true
gsettings set $S manualhide false
gsettings set $S dock-position "'BOTTOM'"
gsettings set $S dash-max-icon-size 40
gsettings set $S hide-delay 0.15
gsettings set $S show-delay 0.15
gsettings set $S show-show-apps-button false
gsettings set $S hot-keys false
gsettings set $S shortcut "[]"

gsettings set org.gnome.shell.keybindings toggle-application-view "['<Super>a', '<Super>d']"
gsettings set org.gnome.shell enabled-extensions \
  "['background-logo@fedorahosted.org', 'dash-to-dock@micxgx.gmail.com', 'no-overview@fthx']"
```

### Kenapa `dock-fixed=false` + `intellihide=true`

Di source Dash to Dock 110 (`docking.js`, fungsi `updateDashVisibility()`), urutan cabangnya:
`manualhide` → `overview` → `dock-fixed` → `intellihide` → `autohide` → **else `_animateOut()`**.

- `dock-fixed=true` = dock permanen dan **klaim strut** (ruang layar), jadi window maximized nggak bisa full dan area bawah "kepotong" dock.
- `dock-fixed=false` + `intellihide=true` = dock tampil saat desktop kosong, **hide begitu ada window yang overlap** area dock, dan muncul lagi saat mouse ke bawah.
- `autohide=true` di sini **bukan** bikin selalu hide: cabang `intellihide` yang menang saat nggak ada overlap (langsung `_animateIn`). `autohide=true` cuma bikin dock bisa di-hover-reveal saat ada window overlap. Kalau `autohide=false` + overlap, kode selalu `_animateOut()` walau mouse diarahkan ke dock — jadi dock nggak bisa dipanggil.
- `intellihide-mode=ALL_WINDOWS` = hide kalau window apa pun overlap (termasuk Firefox maximized). Opsi lain: `FOCUS_APPLICATION_WINDOWS` (default), `MAXIMIZED_WINDOWS` (cuma saat maximized), `ALWAYS_ON_TOP`.
- `dock-fixed=false` juga berarti nggak ada strut/ruang dipesan, jadi window maximized pakai full layar dan nggak kepotong.

### Extension No overview at start-up

- Paket asal: `gnome-shell-extension-no-overview` 51-1.fc45 (Fedora), metadata support GNOME 48–51 ✓.
- Diinstall **tanpa sudo**, ke `~/.local/share/gnome-shell/extensions/no-overview@fthx/` (bukan paket sistem).
- Cara kerja: di event `startup-complete` dia memanggil `Main.overview.hide()`.
- Kalau nanti mau versi sistem: `sudo dnf install gnome-shell-extension-no-overview`, lalu hapus folder user di atas supaya nggak dobel UUID.

Hapus extension user-level:

```bash
rm -rf ~/.local/share/gnome-shell/extensions/no-overview@fthx
gsettings set org.gnome.shell enabled-extensions \
  "['background-logo@fedorahosted.org', 'dash-to-dock@micxgx.gmail.com']"
```

### Kapan aktif

| Perubahan | Aktif |
|---|---|
| `overlay-key ''`, mode dock/intellihide, ukuran ikon, dock position | **langsung** |
| `Super+D` / `Super+A` launcher | **langsung** |
| Extension `no-overview` (login langsung desktop) | **setelah logout/login** |

Di Wayland GNOME Shell nggak bisa di-restart tanpa logout, jadi sekali logout wajib untuk extension baru. Setelah login cek:

```bash
gnome-extensions list --enabled
gsettings get org.gnome.mutter overlay-key
```

Catatan: dengan `overlay-key` kosong, `Super` tetap berfungsi sebagai modifier (semua shortcut `Super+...` aman); yang hilang cuma aksi "tekan Super sendiri".
