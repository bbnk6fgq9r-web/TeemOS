#!/usr/bin/env bash
# 🏗️ Teemo Cat Edition - Automatisk byggescript
# Bygger minimal Puppy Linux ISO med woof-CE

set -euo pipefail

# 📁 Konfigurer stier
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_FILE="${PROJECT_ROOT}/config/teemocat.conf"
WORK_DIR="${HOME}/teemo"
WOOFCE_DIR="${WORK_DIR}/woof-CE"
PROFILE_NAME="teemocat"
OUTPUT_DIR="${WOOFCE_DIR}/woof-out_x86_64/${PROFILE_NAME}/woof-output"

# 🎨 Farger for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 📢 Logger
log_info() {
    echo -e "${BLUE}ℹ️  ${1}${NC}"
}

log_success() {
    echo -e "${GREEN}✅ ${1}${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  ${1}${NC}"
}

log_error() {
    echo -e "${RED}❌ ${1}${NC}"
    exit 1
}

# 🔍 Sjekk om vi kjører på Linux
if [[ "$(uname)" != "Linux" ]]; then
    log_error "Dette scriptet må kjøres på Linux (eller WSL2)"
fi

# 📦 Last inn config
if [[ -f "$CONFIG_FILE" ]]; then
    log_info "Laster konfigurasjon fra $CONFIG_FILE"
    source "$CONFIG_FILE"
else
    log_warning "Ingen config funnet, bruker standardverdier"
    BASE_PROFILE="${BASE_PROFILE:-slacko64}"
    DISTRO_ARCH="${DISTRO_ARCH:-x86_64}"
    ISO_NAME="${ISO_NAME:-TeemoCat}"
fi

# 🛠️ Sjekk avhengigheter
log_info "Sjekker avhengigheter..."
REQUIRED_TOOLS=(git curl rsync bc gcc make zstd xz squashfs-tools mkisofs dd pv)
MISSING_TOOLS=()

for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS+=("$tool")
    fi
done

if [[ ${#MISSING_TOOLS[@]} -gt 0 ]]; then
    log_error "Manglende verktøy: ${MISSING_TOOLS[*]}\nKjør: sudo apt install ${MISSING_TOOLS[*]}"
fi

log_success "Alle avhengigheter installert"

# 🐾 Klon woof-CE hvis ikke allerede gjort
if [[ ! -d "$WOOFCE_DIR" ]]; then
    log_info "Kloner woof-CE fra GitHub..."
    mkdir -p "$WORK_DIR"
    cd "$WORK_DIR"
    git clone https://github.com/woof-CE/woof-CE.git
    log_success "woof-CE klonet til $WOOFCE_DIR"
else
    log_info "woof-CE finnes allerede i $WOOFCE_DIR"
    cd "$WOOFCE_DIR"
    log_info "Oppdaterer woof-CE..."
    git pull origin master || log_warning "Kunne ikke oppdatere woof-CE (fortsetter likevel)"
fi

# 🧩 Velg baseprofil
log_info "Setter opp profil: $BASE_PROFILE"
PROFILE_SOURCE="${WOOFCE_DIR}/woof-distro/${DISTRO_ARCH}/${BASE_PROFILE}"
PROFILE_DEST="${WOOFCE_DIR}/woof-out_${DISTRO_ARCH}/${PROFILE_NAME}"

if [[ ! -d "$PROFILE_SOURCE" ]]; then
    log_error "Baseprofil ikke funnet: $PROFILE_SOURCE"
fi

# Kopier profil hvis ikke allerede gjort
if [[ ! -d "$PROFILE_DEST" ]]; then
    log_info "Kopierer profil fra $BASE_PROFILE..."
    mkdir -p "$(dirname "$PROFILE_DEST")"
    cp -r "$PROFILE_SOURCE" "$PROFILE_DEST"
    log_success "Profil kopiert til $PROFILE_DEST"
else
    log_info "Profil finnes allerede: $PROFILE_DEST"
fi

# ✂️ Trim profil
log_info "Trimmer profil for minimal størrelse..."
if [[ -x "${SCRIPT_DIR}/trim-profile.sh" ]]; then
    "${SCRIPT_DIR}/trim-profile.sh" "$PROFILE_DEST" || log_error "Trimming feilet"
    log_success "Profil trimmet"
else
    log_warning "trim-profile.sh ikke funnet, hopper over trimming"
fi

# 🔗 merge2out
log_info "Kjører merge2out..."
cd "$WOOFCE_DIR"
if [[ -x ./merge2out ]]; then
    ./merge2out "woof-out_${DISTRO_ARCH}/${PROFILE_NAME}" || log_error "merge2out feilet"
    log_success "merge2out fullført"
else
    log_error "merge2out ikke funnet i $WOOFCE_DIR"
fi

# 🏗️ Kjør woof byggesekvens
cd "$PROFILE_DEST"

log_info "Steg 1/4: Kjører 0setup (synkroniserer pakkedatabase)..."
if [[ -x ./0setup ]]; then
    ./0setup || log_error "0setup feilet"
    log_success "0setup fullført"
else
    log_error "0setup ikke funnet"
fi

log_info "Steg 2/4: Kjører 1download (laster ned pakker)..."
if [[ -x ./1download ]]; then
    ./1download || log_error "1download feilet"
    log_success "1download fullført"
else
    log_error "1download ikke funnet"
fi

log_info "Steg 3/4: Kjører 2createpackages (pakker ut og stager)..."
if [[ -x ./2createpackages ]]; then
    ./2createpackages || log_error "2createpackages feilet"
    log_success "2createpackages fullført"
else
    log_error "2createpackages ikke funnet"
fi

log_info "Steg 4/4: Kjører 3builddistro-Z (bygger ISO)..."
if [[ -x ./3builddistro-Z ]]; then
    ./3builddistro-Z || log_error "3builddistro-Z feilet"
    log_success "3builddistro-Z fullført"
else
    log_error "3builddistro-Z ikke funnet"
fi

# 📏 Sjekk ISO størrelse
if [[ -d "$OUTPUT_DIR" ]]; then
    ISO_FILE=$(find "$OUTPUT_DIR" -name "*.iso" -type f | head -n 1)
    if [[ -n "$ISO_FILE" ]]; then
        ISO_SIZE=$(stat -c%s "$ISO_FILE" 2>/dev/null || stat -f%z "$ISO_FILE" 2>/dev/null)
        ISO_SIZE_MB=$((ISO_SIZE / 1024 / 1024))
        
        log_success "ISO bygget: $ISO_FILE"
        log_info "Størrelse: ${ISO_SIZE_MB} MB"
        
        # Kopier til prosjektrot
        FINAL_ISO="${PROJECT_ROOT}/woof-output/${ISO_NAME}.iso"
        mkdir -p "$(dirname "$FINAL_ISO")"
        cp "$ISO_FILE" "$FINAL_ISO"
        log_success "ISO kopiert til $FINAL_ISO"
        
        # Advarsel hvis for stor
        if [[ $ISO_SIZE_MB -gt 900 ]]; then
            log_warning "ISO er større enn ønsket mål (900 MB)!"
            log_info "Vurder å trimme flere pakker eller bruk AGGRESSIVE_TRIM=yes"
        elif [[ $ISO_SIZE_MB -gt 3072 ]]; then
            log_error "ISO er over 3 GB grensen! Må trimmes mer."
        else
            log_success "ISO størrelse er innenfor målet! 🎉"
        fi
    else
        log_error "Ingen ISO funnet i $OUTPUT_DIR"
    fi
else
    log_error "Output-mappe ikke funnet: $OUTPUT_DIR"
fi

# 🎉 Ferdig!
echo ""
log_success "🎉 Teemo Cat Edition bygget!"
echo ""
log_info "Neste steg:"
echo "  1. Test ISO i VM: qemu-system-x86_64 -cdrom $FINAL_ISO -m 2G"
echo "  2. Flash til USB: ./scripts/flash-usb.sh"
echo ""
