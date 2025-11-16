# 😺 Teemo Cat Edition

> Minimal Puppy Linux ISO built with woof-CE  
> **Mål:** ISO < 3 GB (helst 300–900 MB) • LXDE/Openbox • NetSurf eller Pale Moon

---

## 🚀 Rask Start

### Forutsetninger

- **Linux build-host** (Debian/Ubuntu eller WSL2 med Ubuntu)
- `git`, `build-essential`, `squashfs-tools`, `xorriso`, `syslinux`, `pv`
- ~5 GB ledig diskplass

### Installer verktøy

```bash
sudo apt update
sudo apt install -y git curl rsync bc build-essential zstd xz-utils \
  squashfs-tools dosfstools syslinux-utils genisoimage cpio \
  wget gawk sed tar bzip2 xorriso coreutils util-linux pv
```

### Bygg ISO

```bash
# 🐾 Klon dette repoet
git clone https://github.com/bbnk6fgq9r-web/TeemOS.git
cd TeemOS

# 🏗️ Kjør automatisk byggeskript
./scripts/build-teemocat.sh

# ✅ ISO vil bli generert i woof-output/TeemoCat.iso
```

### Flash til USB

```bash
# 💾 Skriv til USB (≤3 GB)
./scripts/flash-usb.sh
```

---

## 📂 Prosjektstruktur

```text
TeemOS/
├── .github/
│   └── copilot.yml          # GitHub Copilot instruksjoner
├── scripts/
│   ├── build-teemocat.sh    # Hovedbyggescript
│   ├── trim-profile.sh      # Trimmer baseprofil
│   └── flash-usb.sh         # Flasher ISO til USB
├── config/
│   ├── teemocat.conf        # Byggeparametere
│   └── packages.txt         # Minimal pakkeliste
├── docs/
│   └── TRIMMING.md          # Veiledning for pakketrimming
└── woof-output/
    └── TeemoCat.iso         # Ferdig ISO (genereres ved bygg)
```

---

## 🎯 Byggekrav

| Komponent | Valg |
|-----------|------|
| **Baseprofil** | Slacko64 eller Debian-lite |
| **Skrivebord** | LXDE/Openbox |
| **Nettleser** | NetSurf (primær) eller Pale Moon |
| **Størrelse** | < 3 GB, ideelt 300–900 MB |
| **Språk** | Kun engelsk (fjerner alle langpacks) |
| **Media** | Ingen tunge multimedia-pakker |

---

## 🔧 Manuell Bygging

### 1️⃣ Klon woof-CE

```bash
mkdir -p ~/teemo && cd ~/teemo
git clone https://github.com/woof-CE/woof-CE.git
cd woof-CE
```

### 2️⃣ Velg og trim profil

```bash
# Kopier Slacko64 profil
cp -r woof-distro/x86_64/slacko64 woof-out_x86_64/teemocat

# Kjør trimming-script
cd woof-out_x86_64/teemocat
~/TeemOS/scripts/trim-profile.sh
```

### 3️⃣ Kjør woof byggesekvens

```bash
# merge2out
cd ~/teemo/woof-CE
./merge2out woof-out_x86_64/teemocat

# Byggesekvens
cd woof-out_x86_64/teemocat
./0setup    # Synkroniser pakkedatabase
./1download # Last ned pakker
./2createpackages # Pakk ut og stage
./3builddistro-Z  # Bygg ISO

# Sjekk størrelse
ls -lh woof-output/TeemoCat.iso
```

---

## 📦 Pakketrimming

For å holde ISO-en minimal:

- ✅ **Behold:** LXDE, Openbox, NetSurf, grunnleggende utils
- ❌ **Fjern:** KDE, GNOME, Firefox, språkpakker, multimedia-suiter
- 🔧 **Rediger:** `DISTRO_PKGS_SPECS-*` i profilmappen

Se [docs/TRIMMING.md](docs/TRIMMING.md) for detaljer.

---

## 🐛 Feilsøking

### ISO for stor (>900 MB)?

```bash
# Kjør trimming-script på nytt med strengere krav
AGGRESSIVE_TRIM=yes ./scripts/trim-profile.sh

# Eller manuelt fjern pakker
cd woof-out_x86_64/teemocat
sed -i 's/^yes|<pakkenavn>|.*/no|<pakkenavn>|Removed/' DISTRO_PKGS_SPECS-*
```

### Byggefeil i 3builddistro-Z?

```bash
# Sjekk loggfiler
cat /tmp/3builddistro.log

# Reinstaller manglende verktøy
sudo apt install --reinstall squashfs-tools xorriso syslinux-utils
```

### USB booter ikke?

- Bekreft BIOS/UEFI innstillinger (Legacy vs UEFI)
- Test ISO i VM først: `qemu-system-x86_64 -cdrom TeemoCat.iso -m 2G`

---

## 📝 Lisens

Dette prosjektet følger woof-CE sin GPL-2.0 lisens.  
Puppy Linux er et fellesskapsprosjekt, se [puppylinux.com](https://puppylinux.com).

---

## 🤝 Bidra

1. Fork dette repoet
2. Lag en branch: `git checkout -b feature/min-forbedring`
3. Commit endringer: `git commit -am 'Legg til funksjon X'`
4. Push til branch: `git push origin feature/min-forbedring`
5. Åpne en Pull Request

---

## 🔗 Ressurser

- [woof-CE GitHub](https://github.com/woof-CE/woof-CE)
- [Puppy Linux Forum](https://forum.puppylinux.com)
- [NetSurf Browser](https://www.netsurf-browser.org)
- [LXDE Desktop](https://lxde.org)

---

**Bygget med ❤️ og ☕ for minimal Linux-opplevelse**
