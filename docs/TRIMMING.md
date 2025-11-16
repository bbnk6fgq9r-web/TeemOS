# 📦 Pakketrimming for Teemo Cat Edition

Denne guiden viser hvordan du trimmer pakker for å holde ISO < 900 MB.

---

## 🎯 Trimmingsstrategi

### 1️⃣ Automatisk Trimming

Bruk det inkluderte scriptet:

```bash
./scripts/trim-profile.sh /path/to/profile
```

For mer aggressiv trimming:

```bash
AGGRESSIVE_TRIM=yes ./scripts/trim-profile.sh /path/to/profile
```

### 2️⃣ Manuell Trimming

Rediger `DISTRO_PKGS_SPECS-*` filene i profilmappen:

```bash
cd woof-out_x86_64/teemocat
nano DISTRO_PKGS_SPECS-slacko64
```

Format: `yes|pakkenavn|beskrivelse`

- `yes` = inkludert
- `no` = ekskludert

**Eksempel:**

```text
# Fjern Firefox
yes|firefox|Web browser    # GAMMEL
no|firefox|Removed         # NY

# Behold NetSurf
yes|netsurf|Light browser  # BEHOLD
```

---

## ❌ Pakker som ALLTID Skal Fjernes

### 🖥️ Tunge Skrivebord

- `kde`, `plasma`, `gnome`, `xfce4` (bruk LXDE/Openbox)

### 🌐 Tunge Nettlesere

- `firefox`, `chromium`, `google-chrome` (bruk NetSurf)

### 📺 Multimedia

- `vlc`, `gimp`, `inkscape`, `libreoffice`

### 🌍 Språkpakker

- `language_pack_*`, `langpack_*`, `locale_*` (behold kun engelsk)

### 🛠️ Utviklerverktøy

- `gcc`, `g++`, `make`, `cmake`, `*-dev`, `*-doc`

---

## ✅ Pakker som SKAL Beholdes

### 🎨 Lett Skrivebord

- `lxde`, `openbox`, `pcmanfm`, `lxterminal`

### 🌐 Lett Nettleser

- `netsurf`, `dillo`, `links2`

### 🛠️ Grunnleggende Utils

- `busybox`, `coreutils`, `bash`, `nano`

### 🌐 Nettverk

- `dhcpcd`, `wpa_supplicant`, `iw`

---

## 📏 Størrelsesjekk

Etter bygg, sjekk ISO-størrelse:

```bash
ls -lh woof-output/TeemoCat.iso
```

**Mål:**
- ✅ **< 300 MB:** Ekstremt minimal (perfekt!)
- ✅ **300-600 MB:** Optimal størrelse
- ⚠️ **600-900 MB:** Akseptabelt (kan trimmes mer)
- ❌ **> 900 MB:** For stor, må trimmes

---

## 🔧 Avansert Trimming

### Fjern Spesifikke Filer

Rediger `rootfs-skeleton/`:
```bash
cd woof-out_x86_64/teemocat/rootfs-skeleton
rm -rf usr/share/doc/*
rm -rf usr/share/man/*
rm -rf usr/share/locale/* (behold kun en_US)
```

### Strippe Binaries

Rediger `3builddistro` for å legge til:
```bash
find rootfs-complete -type f -executable -exec strip --strip-unneeded {} \; 2>/dev/null
```

### XZ Maksimal Kompresjon

I `3builddistro-Z`, endre:
```bash
mksquashfs sandbox rootfs.sfs -comp xz -Xbcj x86 -b 1M -Xdict-size 100%
```

---

## 🐛 Feilsøking

### ISO fortsatt for stor?

1. **Sjekk hva som tar plass:**
```bash
cd woof-out_x86_64/teemocat/rootfs-complete
du -sh * | sort -h
```

2. **Identifiser store filer:**
```bash
find . -type f -size +10M
```

3. **Fjern unødvendige:**
```bash
rm -rf usr/share/doc/*
rm -rf usr/share/man/*
rm -rf var/cache/*
```

### Manglende avhengigheter etter trimming?

Test i QEMU først:
```bash
qemu-system-x86_64 -cdrom TeemoCat.iso -m 512M
```

Legg tilbake kritiske pakker hvis noe ikke fungerer.

---

## 📊 Trimming Checklist

- [ ] Fjernet KDE/GNOME/Xfce
- [ ] Fjernet Firefox/Chromium
- [ ] Fjernet språkpakker (beholdt kun engelsk)
- [ ] Fjernet *-doc og *-dev pakker
- [ ] Fjernet multimedia-suiter
- [ ] Beholdt LXDE/Openbox
- [ ] Beholdt NetSurf/Dillo
- [ ] Beholdt grunnleggende network-tools
- [ ] Testet ISO i VM
- [ ] Verifisert størrelse < 900 MB

---

## 📖 Ressurser

- [woof-CE Documentation](https://github.com/woof-CE/woof-CE/wiki)
- [Puppy Linux Forum](https://forum.puppylinux.com)
- [SquashFS Tools Manual](https://man7.org/linux/man-pages/man1/mksquashfs.1.html)
