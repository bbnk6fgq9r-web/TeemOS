# 🔧 Development Guide

Guide for utviklere som vil bidra til Teemo Cat Edition.

---

## 🏗️ Prosjektstruktur

```
TeemOS/
├── .github/
│   ├── copilot.yml           # GitHub Copilot instruksjoner
│   └── workflows/            # CI/CD workflows (fremtidig)
├── config/
│   ├── teemocat.conf         # Hovedkonfigurasjon
│   └── packages.txt          # Pakkeliste
├── docs/
│   ├── GETTING-STARTED.md    # Hurtigstart guide
│   ├── TRIMMING.md           # Pakketrimming guide
│   └── DEVELOPMENT.md        # Denne filen
├── scripts/
│   ├── build-teemocat.sh     # Hovedbyggescript
│   ├── trim-profile.sh       # Pakketrimming
│   └── flash-usb.sh          # USB flasher
├── woof-output/              # Generert ISO (ikke i git)
└── README.md                 # Hovedreadme
```

---

## 🛠️ Utviklingsmiljø

### Forutsetninger

```bash
# Ubuntu/Debian
sudo apt install git build-essential squashfs-tools xorriso \
  shellcheck shfmt bash-completion

# Valgfritt: Docker for isolert bygging
sudo apt install docker.io docker-compose
```

### Klon og Setup

```bash
git clone https://github.com/<your-org>/TeemOS.git
cd TeemOS

# Gjør scripts kjørbare
chmod +x scripts/*.sh

# Valider scripts
shellcheck scripts/*.sh
```

---

## 📝 Kode-standarder

### Bash Scripts

**Overskrift:**
```bash
#!/usr/bin/env bash
# 🏗️ Script Tittel
# Kort beskrivelse

set -euo pipefail  # Streng feilhåndtering
```

**Logging:**
```bash
log_info "Informasjon"
log_success "Suksess"
log_warning "Advarsel"
log_error "Feil"  # Exit automatisk
```

**Fargekoder:**
```bash
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'  # No Color
```

### Markdown

- Bruk emoji-prefixes i headings (📦, 🚀, etc.)
- Fenced code blocks med språkmerking
- Inline-kode for filnavn: `config/teemocat.conf`

---

## 🧪 Testing

### Lokal Testing

**Test script-syntaks:**
```bash
bash -n scripts/build-teemocat.sh
shellcheck scripts/*.sh
```

**Test bygg:**
```bash
./scripts/build-teemocat.sh
ls -lh woof-output/TeemoCat.iso
```

**Test i VM:**
```bash
# QEMU
qemu-system-x86_64 -cdrom woof-output/TeemoCat.iso -m 2G -enable-kvm

# VirtualBox
VBoxManage createvm --name TeemoCat --register
VBoxManage modifyvm TeemoCat --memory 2048 --boot1 dvd
VBoxManage storagectl TeemoCat --name IDE --add ide
VBoxManage storageattach TeemoCat --storagectl IDE --port 0 --device 0 \
  --type dvddrive --medium woof-output/TeemoCat.iso
VBoxManage startvm TeemoCat
```

### CI/CD Testing

Se `.github/workflows/build.yml` (kommer snart).

---

## 🔄 Workflow

### Feature Development

```bash
# 1. Opprett branch
git checkout -b feature/my-feature

# 2. Gjør endringer
nano scripts/build-teemocat.sh

# 3. Test
./scripts/build-teemocat.sh

# 4. Commit
git add scripts/build-teemocat.sh
git commit -m "feat: Legg til feature X"

# 5. Push
git push origin feature/my-feature

# 6. Opprett PR på GitHub
```

### Bugfix

```bash
git checkout -b fix/issue-123
# Fix bug
git commit -m "fix: Løs issue #123"
git push origin fix/issue-123
```

### Commit Messages

Følg [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Ny funksjonalitet
- `fix:` Bugfix
- `docs:` Dokumentasjon
- `style:` Formatering
- `refactor:` Kode refactoring
- `test:` Tester
- `chore:` Maintenance

**Eksempler:**
```
feat: Legg til støtte for Alpine Linux base
fix: Korrigere ISO størrelse beregning
docs: Oppdater TRIMMING.md med nye pakker
```

---

## 🐛 Debugging

### Build Debugging

**Verbose mode:**
```bash
VERBOSE_BUILD=yes ./scripts/build-teemocat.sh
```

**Sjekk logg:**
```bash
tail -f /tmp/3builddistro.log
```

**Inspisere rootfs:**
```bash
cd ~/teemo/woof-CE/woof-out_x86_64/teemocat/rootfs-complete
du -sh *
find . -type f -size +10M
```

### Script Debugging

```bash
# Kjør med bash debug mode
bash -x scripts/build-teemocat.sh

# Eller legg til i script
set -x  # Enable debug
set +x  # Disable debug
```

---

## 📦 Pakkehåndtering

### Legge til Pakke

1. Rediger `config/packages.txt`:
```bash
nano config/packages.txt
# Legg til: package_name | description | category
```

2. Oppdater `scripts/trim-profile.sh`:
```bash
# Legg til i KEEP_PACKAGES array
KEEP_PACKAGES+=(
    "new_package"
)
```

3. Test bygg:
```bash
./scripts/build-teemocat.sh
```

### Fjerne Pakke

1. Rediger `config/packages.txt` (kommenter ut)
2. Legg til i `REMOVE_PACKAGES` i `scripts/trim-profile.sh`
3. Rebuild

---

## 🔐 Sikkerhet

### Skann for Sikkerhetsproblemer

```bash
# Shellcheck for scripts
shellcheck -S warning scripts/*.sh

# Sjekk for hardkodede secrets
git secrets --scan

# Trivy for ISO scanning (valgfritt)
trivy image --input woof-output/TeemoCat.iso
```

---

## 📊 Performance

### Optimalisering

**Parallel builds:**
```bash
# config/teemocat.conf
BUILD_JOBS="$(nproc)"
```

**Kompresjon:**
```bash
# config/teemocat.conf
SQUASHFS_COMP="xz"       # Beste kompresjon
XZ_COMPRESSION_LEVEL=9   # Maksimal
```

**Caching:**
```bash
# Behold woof-CE repo for raskere rebuilds
CLEANUP_AFTER_BUILD="no"
```

---

## 🚀 Release Process

### Versjonering

Følg [Semantic Versioning](https://semver.org/):
- `MAJOR.MINOR.PATCH`
- Eksempel: `1.0.0`, `1.1.0`, `1.1.1`

### Lage Release

```bash
# 1. Oppdater versjon
nano config/teemocat.conf
DISTRO_VERSION="1.1.0"

# 2. Bygg
./scripts/build-teemocat.sh

# 3. Test
qemu-system-x86_64 -cdrom woof-output/TeemoCat.iso -m 2G

# 4. Tag
git tag -a v1.1.0 -m "Release v1.1.0"
git push origin v1.1.0

# 5. GitHub Release
# - Last opp TeemoCat.iso
# - Skriv changelog
# - Publish
```

---

## 📚 Ressurser

### Dokumentasjon

- [woof-CE Wiki](https://github.com/woof-CE/woof-CE/wiki)
- [Puppy Linux Build Guide](https://puppylinux.com/wiki/build)
- [Bash Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Markdown Guide](https://www.markdownguide.org/)

### Tools

- [ShellCheck](https://www.shellcheck.net/) - Shell script linting
- [shfmt](https://github.com/mvdan/sh) - Shell script formatting
- [QEMU](https://www.qemu.org/) - VM testing
- [Trivy](https://trivy.dev/) - Security scanning

---

### Community

- **Issues:** [GitHub Issues](https://github.com/bbnk6fgq9r-web/TeemOS/issues)
- **Discussions:** [GitHub Discussions](https://github.com/bbnk6fgq9r-web/TeemOS/discussions)
- **Forum:** [Puppy Linux Community](https://forum.puppylinux.com)

---

**Takk for at du bidrar til Teemo Cat Edition! 😺**
