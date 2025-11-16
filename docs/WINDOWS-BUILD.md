# 🪟 Teemo Cat Edition - Windows Build Guide

**OBS:** Puppy Linux bygges normalt på Linux. Denne guiden viser alternativer for Windows-brukere.

---

## ✅ Løsning 1: GitHub Actions (Anbefalt - Ingen lokal bygging)

GitHub kan bygge ISO-en automatisk i skyen:

### Oppsett

1. **Push prosjektet til GitHub:**
   ```powershell
   cd D:\TeemOS
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/bbnk6fgq9r-web/TeemOS.git
   git push -u origin main
   ```

2. **Opprett GitHub Actions workflow:**
   Jeg lager dette for deg automatisk (se `.github/workflows/build.yml`)

3. **Trigger build:**
   - Gå til GitHub Actions tab
   - Klikk "Run workflow"
   - Vent 30-60 min
   - Last ned ferdig ISO fra Artifacts

---

## ✅ Løsning 2: Docker Desktop (Krever Admin)

### Installasjon

1. **Last ned Docker Desktop:**
   https://www.docker.com/products/docker-desktop

2. **Installer uten WSL2:**
   - Velg "Use Hyper-V instead of WSL2" under installasjon
   - ELLER velg "Windows containers"

3. **Bygg ISO:**
   ```powershell
   cd D:\TeemOS
   docker-compose up build
   ```

---

## ✅ Løsning 3: VirtualBox (Fungerer uten virtualisering i BIOS)

### Oppsett

1. **Last ned VirtualBox:**
   https://www.virtualbox.org/wiki/Downloads

2. **Last ned Ubuntu ISO:**
   https://ubuntu.com/download/desktop/thank-you?version=22.04.3&architecture=amd64

3. **Opprett VM:**
   ```
   Navn: TeemoBuild
   Type: Linux
   Versjon: Ubuntu (64-bit)
   RAM: 4096 MB
   Disk: 20 GB dynamisk
   ```

4. **Installer Ubuntu og bygg:**
   ```bash
   # I Ubuntu VM:
   sudo apt update
   sudo apt install -y git build-essential squashfs-tools xorriso
   git clone https://github.com/bbnk6fgq9r-web/TeemOS.git
   cd TeemOS
   ./scripts/build-teemocat.sh
   ```

5. **Kopier ISO ut:**
   - Installer VirtualBox Guest Additions
   - Del D:\TeemOS som shared folder
   - Kopier ISO fra VM til Windows

---

## ✅ Løsning 4: GitHub Codespaces (Gratis)

### Bruk nettleser-basert Linux

1. **Push til GitHub** (se Løsning 1)

2. **Åpne Codespace:**
   - Gå til GitHub repo
   - Klikk Code → Codespaces → Create codespace
   - Vent på miljøet lastes (2-3 min)

3. **Bygg i nettleser:**
   ```bash
   cd /workspaces/TeemOS
   ./scripts/build-teemocat.sh
   ```

4. **Last ned ISO:**
   - Høyreklikk på `woof-output/TeemoCat.iso`
   - Velg "Download"

**Gratis tier:** 60 timer/måned

---

## ✅ Løsning 5: Dual-boot eller Live USB

### Bruk Ubuntu uten installasjon

1. **Lag Ubuntu Live USB:**
   - Last ned Rufus: https://rufus.ie
   - Last ned Ubuntu ISO
   - Flash til USB med Rufus
   - Velg "Persistent storage" (4-8 GB)

2. **Boot fra USB:**
   - Restart PC
   - Trykk F12/F8/ESC for boot menu
   - Velg USB
   - Velg "Try Ubuntu"

3. **Bygg ISO:**
   ```bash
   # I Live Ubuntu:
   sudo apt update
   sudo apt install -y git build-essential squashfs-tools xorriso
   git clone https://github.com/bbnk6fgq9r-web/TeemOS.git
   cd TeemOS
   ./scripts/build-teemocat.sh
   
   # Kopier til USB persistence:
   cp woof-output/TeemoCat.iso ~/Desktop/
   ```

---

## 🎯 Min anbefaling for deg

**Siden du ikke har virtualisering:**

### 🥇 Første prioritet: GitHub Actions
- Ingen lokal installasjon nødvendig
- Bygger i skyen
- 100% gratis for public repos
- Tar 5 min å sette opp

### 🥈 Andre prioritet: VirtualBox
- Fungerer selv uten hardware virtualisering (tregere)
- Full kontroll
- Kan brukes offline

### 🥉 Tredje prioritet: GitHub Codespaces
- Nettleser-basert
- 60 timer gratis/måned
- Ingen lokal installasjon

---

## 🔧 Aktiver virtualisering (valgfritt)

Hvis du vil bruke WSL2 senere:

1. **Gå inn i BIOS:**
   - Restart PC
   - Trykk F2/Del/F10 (avhenger av PC)

2. **Finn virtualiseringsinnstillinger:**
   - Intel: "Intel VT-x" eller "Virtualization Technology"
   - AMD: "AMD-V" eller "SVM Mode"

3. **Aktiver og lagre**

4. **I Windows:**
   ```powershell
   # Aktiver Windows-funksjoner
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   
   # Restart
   Restart-Computer
   
   # Etter restart:
   wsl --install
   ```

---

## ❓ Hva vil du gjøre?

1. **GitHub Actions** - Jeg setter det opp for deg nå?
2. **Docker Desktop** - Jeg lager Dockerfile og docker-compose.yml?
3. **VirtualBox** - Jeg gir deg detaljert guide?
4. **Codespaces** - Jeg setter opp devcontainer?
5. **Aktiver virtualisering** - Jeg guider deg gjennom BIOS?

Fortell meg hva som passer best for deg! 😺
