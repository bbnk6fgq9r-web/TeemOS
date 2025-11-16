# 🚀 Kom i gang med Teemo Cat Edition

Rask veiledning for å bygge din første minimal Puppy Linux ISO.

---

## ⚡ Hurtigstart (5 minutter)

### 1. Klon repoet

```bash
git clone https://github.com/bbnk6fgq9r-web/TeemOS.git
cd TeemOS
```

### 2. Installer avhengigheter (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install -y git curl rsync bc build-essential zstd xz-utils \
  squashfs-tools dosfstools syslinux-utils genisoimage cpio \
  wget gawk sed tar bzip2 xorriso coreutils util-linux pv
```

### 3. Kjør byggescript

```bash
chmod +x scripts/*.sh
./scripts/build-teemocat.sh
```

### 4. Flash til USB

```bash
sudo ./scripts/flash-usb.sh
```

---

## 📖 Detaljert Veiledning

### Forutsetninger

**Maskinvare:**

- 5 GB ledig diskplass
- 2 GB RAM (4 GB anbefalt)
- USB-stick ≤ 3 GB

**Software:**

- Linux host (Ubuntu 20.04+, Debian 11+, eller WSL2)
- Bash 4.0+
- Internet-tilgang

### Steg-for-steg

#### 📥 Installasjon

**Ubuntu/Debian:**

```bash
sudo apt install git build-essential squashfs-tools xorriso pv
```

**Arch Linux:**

```bash
sudo pacman -S git base-devel squashfs-tools libisoburn pv
```

**Fedora:**

```bash
sudo dnf install git gcc make squashfs-tools xorriso pv
```

#### 🏭️ Bygging

**Standard bygg:**

```bash
./scripts/build-teemocat.sh
```

**Aggressiv trimming (< 500 MB):**

```bash
AGGRESSIVE_TRIM=yes ./scripts/build-teemocat.sh
```

**Custom konfigurasjon:**

```bash
# Rediger config først
nano config/teemocat.conf

# Deretter bygg
./scripts/build-teemocat.sh
```

#### 🧪 Testing

**Test i QEMU:**

```bash
# Installer QEMU
sudo apt install qemu-system-x86

# Kjør ISO
qemu-system-x86_64 -cdrom woof-output/TeemoCat.iso -m 2G -enable-kvm
```

**Test i VirtualBox:**

1. Opprett ny VM (Linux, 64-bit)
2. Allokér 1-2 GB RAM
3. Mount `woof-output/TeemoCat.iso` som CD
4. Start VM

#### 💾 Flashing til USB

**Linux:**

```bash
sudo ./scripts/flash-usb.sh
```

**Windows (WSL):**

```powershell
# Last ned Rufus: https://rufus.ie
# Velg TeemoCat.iso
# Velg USB-device
# Start
```

**macOS:**

```bash
# Finn USB device
diskutil list

# Flash (erstatt diskN)
sudo dd if=woof-output/TeemoCat.iso of=/dev/diskN bs=4m
sudo diskutil eject /dev/diskN
```

---

## 🐛 Vanlige Problemer

### Byggefeil: "Command not found"

**Problem:** Manglende avhengigheter

**Løsning:**

```bash
sudo apt install --reinstall squashfs-tools xorriso syslinux-utils
```

### ISO for stor (> 900 MB)

**Problem:** For mange pakker inkludert

**Løsning:**

```bash
# Kjør aggressiv trimming
AGGRESSIVE_TRIM=yes ./scripts/trim-profile.sh ~/teemo/woof-CE/woof-out_x86_64/teemocat

# Rebuild
./scripts/build-teemocat.sh
```

### USB booter ikke

**Problem:** BIOS/UEFI innstillinger

**Løsning:**

1. Restart og trykk F2/Del for BIOS
2. Gå til Boot-menyen
3. Enable "USB Boot" eller "Legacy Boot"
4. Sett USB øverst i boot-order
5. Lagre og restart

### "Permission denied" ved flash

**Problem:** Ikke root/sudo

**Løsning:**

```bash
sudo ./scripts/flash-usb.sh
```

---

## 🎯 Neste Steg

### Tilpass ISO

**Endre skrivebord:**

```bash
nano config/teemocat.conf
# Endre DISTRO_DESKTOP="jwm" eller "openbox"
./scripts/build-teemocat.sh
```

**Legg til pakker:**

```bash
nano config/packages.txt
# Uncomment ønskede pakker
./scripts/build-teemocat.sh
```

### Automatiser med CI/CD

Se [docs/CI-CD.md](CI-CD.md) for GitHub Actions setup.

### Bidra

1. Fork repoet
2. Opprett en branch: `git checkout -b feature/min-feature`
3. Commit: `git commit -am 'Add feature'`
4. Push: `git push origin feature/min-feature`
5. Opprett Pull Request

---

## 📚 Ressurser

- [Puppy Linux Dokumentasjon](https://puppylinux.com/wiki)
- [woof-CE Wiki](https://github.com/woof-CE/woof-CE/wiki)
- [TRIMMING.md](TRIMMING.md) - Detaljert pakkeveiledning
- [Puppy Linux Forum](https://forum.puppylinux.com)

---

## 💬 Hjelp og Support

**Issues:** [GitHub Issues](https://github.com/bbnk6fgq9r-web/TeemOS/issues)  
**Forum:** [Puppy Linux Community](https://forum.puppylinux.com)  
**Wiki:** [Project Wiki](https://github.com/bbnk6fgq9r-web/TeemOS/wiki)

---

**Lykke til med byggingen! 😺**
