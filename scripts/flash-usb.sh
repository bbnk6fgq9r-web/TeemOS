#!/usr/bin/env bash
# 💾 Teemo Cat Edition - USB Flash Script
# Flasher ISO til USB-disk med sikkerhetskontroller

set -euo pipefail

# 🎨 Farger
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  ${1}${NC}"; }
log_success() { echo -e "${GREEN}✅ ${1}${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  ${1}${NC}"; }
log_error() { echo -e "${RED}❌ ${1}${NC}"; exit 1; }
log_prompt() { echo -e "${BOLD}🧷 ${1}${NC}"; }

# 📁 Finn ISO-fil
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ISO_FILE="${1:-${PROJECT_ROOT}/woof-output/TeemoCat.iso}"

if [[ ! -f "$ISO_FILE" ]]; then
    log_error "ISO-fil ikke funnet: $ISO_FILE\nBygg ISO først med: ./scripts/build-teemocat.sh"
fi

ISO_SIZE=$(stat -c%s "$ISO_FILE" 2>/dev/null || stat -f%z "$ISO_FILE" 2>/dev/null)
ISO_SIZE_MB=$((ISO_SIZE / 1024 / 1024))
ISO_SIZE_GB=$(echo "scale=2; $ISO_SIZE_MB / 1024" | bc)

log_info "ISO funnet: $ISO_FILE"
log_info "Størrelse: ${ISO_SIZE_MB} MB (${ISO_SIZE_GB} GB)"

# 🔍 Sjekk om vi kjører som root
if [[ $EUID -ne 0 ]]; then
    log_warning "Dette scriptet trenger sudo/root for å skrive til USB"
    log_info "Prøver å reexecute med sudo..."
    exec sudo "$0" "$@"
fi

# 🗂️ Vis tilgjengelige disk-enheter
echo ""
log_info "Tilgjengelige disk-enheter:"
echo ""

if command -v lsblk &> /dev/null; then
    lsblk -d -o NAME,SIZE,TYPE,MOUNTPOINT,MODEL | grep -E "(disk|loop)" || true
else
    fdisk -l | grep "Disk /dev/" || true
fi

echo ""
log_warning "⚠️  ADVARSEL: Alle data på målenheten vil bli SLETTET!"
echo ""

# 🧷 Be bruker velge enhet
log_prompt "Skriv inn USB-enhet (f.eks. /dev/sdb eller /dev/sdc):"
read -r USB_DEVICE

# 🔍 Valider enhet
if [[ ! -b "$USB_DEVICE" ]]; then
    log_error "Ugyldig enhet: $USB_DEVICE"
fi

# 🚫 Sikkerhetskontroller
# Ikke tillat /dev/sda (hovedisk)
if [[ "$USB_DEVICE" == "/dev/sda" ]]; then
    log_error "Kan ikke bruke /dev/sda (hovedisk)! Bruk USB-disk."
fi

# Sjekk om enheten er montert
MOUNTED_PARTS=$(mount | grep "^${USB_DEVICE}" | cut -d' ' -f1 || true)
if [[ -n "$MOUNTED_PARTS" ]]; then
    log_warning "Følgende partisjoner er montert: $MOUNTED_PARTS"
    log_info "Avmonterer..."
    for part in $MOUNTED_PARTS; do
        umount "$part" || log_warning "Kunne ikke avmontere $part"
    done
fi

# 📊 Vis enhetsinfo
echo ""
log_info "Enhetsinformasjon:"
if command -v lsblk &> /dev/null; then
    lsblk "$USB_DEVICE" -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
else
    fdisk -l "$USB_DEVICE" | head -n 10
fi
echo ""

# 💾 Sjekk diskplass
DEVICE_SIZE=$(blockdev --getsize64 "$USB_DEVICE" 2>/dev/null || echo "0")
DEVICE_SIZE_GB=$(echo "scale=2; $DEVICE_SIZE / 1024 / 1024 / 1024" | bc)

log_info "USB-størrelse: ${DEVICE_SIZE_GB} GB"

if (( $(echo "$DEVICE_SIZE_GB < $ISO_SIZE_GB" | bc -l) )); then
    log_error "USB-disk for liten! Trenger minst ${ISO_SIZE_GB} GB, har ${DEVICE_SIZE_GB} GB"
fi

if (( $(echo "$DEVICE_SIZE_GB > 3.5" | bc -l) )); then
    log_warning "USB-disk større enn 3.5 GB - vurder å bruke mindre disk"
fi

# ✅ Bekreft før skriving
log_warning "⚠️  Alle data på $USB_DEVICE vil bli SLETTET!"
log_prompt "Er du sikker? Skriv 'YES' for å fortsette:"
read -r CONFIRM

if [[ "$CONFIRM" != "YES" ]]; then
    log_info "Avbrutt av bruker"
    exit 0
fi

# 🚀 Flash ISO til USB
echo ""
log_info "Flasher ISO til $USB_DEVICE..."
log_warning "Dette kan ta flere minutter. IKKE FJERN USB!"
echo ""

# Bruk pv for progresjonsmåler hvis tilgjengelig
if command -v pv &> /dev/null; then
    pv "$ISO_FILE" | dd of="$USB_DEVICE" bs=4M conv=fsync status=none
else
    dd if="$ISO_FILE" of="$USB_DEVICE" bs=4M conv=fsync status=progress
fi

# 🔄 Synkroniser filsystem
log_info "Synkroniserer filsystem..."
sync
echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true

# ✅ Verifiser skriving (valgfritt)
log_info "Verifiserer skriving..."
ISO_MD5=$(md5sum "$ISO_FILE" | cut -d' ' -f1)
USB_MD5=$(dd if="$USB_DEVICE" bs=4M count=$((ISO_SIZE / 4194304 + 1)) 2>/dev/null | md5sum | cut -d' ' -f1)

if [[ "$ISO_MD5" == "$USB_MD5" ]]; then
    log_success "Verifikasjon OK! ISO skrevet riktig."
else
    log_warning "Verifikasjon feilet - MD5 mismatch"
    log_info "ISO MD5: $ISO_MD5"
    log_info "USB MD5: $USB_MD5"
    log_warning "USB kan fortsatt være OK, test boot i VM eller hardware"
fi

# 📊 Vis resultat
echo ""
log_success "🎉 ISO flashet til $USB_DEVICE!"
echo ""
log_info "Neste steg:"
echo "  1. Fjern USB trygt (kan ta noen sekunder)"
echo "  2. Boot fra USB i BIOS/UEFI"
echo "  3. Velg boot-device i oppstartsmeny (ofte F12/F8/DEL)"
echo ""
log_info "Feilsøking:"
echo "  - Hvis ikke boot: Sjekk BIOS Legacy/UEFI innstillinger"
echo "  - Test i VM først: qemu-system-x86_64 -drive file=${USB_DEVICE},format=raw -m 2G"
echo ""

# 🧹 Cleanup
log_info "Du kan nå fjerne USB-disken trygt"
