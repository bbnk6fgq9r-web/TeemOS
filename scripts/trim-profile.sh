#!/usr/bin/env bash
# ✂️ Teemo Cat Edition - Profile Trimming Script
# Fjerner unødvendige pakker for å holde ISO < 900 MB

set -euo pipefail

# 🎨 Farger
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  ${1}${NC}"; }
log_success() { echo -e "${GREEN}✅ ${1}${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  ${1}${NC}"; }
log_error() { echo -e "${RED}❌ ${1}${NC}"; exit 1; }

# 📁 Profil-mappe (kan gis som argument)
PROFILE_DIR="${1:-}"
AGGRESSIVE="${AGGRESSIVE_TRIM:-no}"

if [[ -z "$PROFILE_DIR" ]]; then
    log_error "Bruk: $0 <profil-mappe>"
fi

if [[ ! -d "$PROFILE_DIR" ]]; then
    log_error "Profil-mappe finnes ikke: $PROFILE_DIR"
fi

cd "$PROFILE_DIR"
log_info "Trimmer profil i: $PROFILE_DIR"

# 🔍 Finn DISTRO_PKGS_SPECS filer
SPECS_FILES=($(find . -maxdepth 1 -name "DISTRO_PKGS_SPECS-*" -type f))

if [[ ${#SPECS_FILES[@]} -eq 0 ]]; then
    log_error "Ingen DISTRO_PKGS_SPECS-* filer funnet"
fi

log_info "Funnet ${#SPECS_FILES[@]} pakkespec-fil(er)"

# 📦 Pakker som SKAL fjernes (tunge komponenter)
REMOVE_PACKAGES=(
    # 🖥️ Tunge skrivebordsmiljøer
    "kde" "plasma" "gnome" "xfce4" "mate" "cinnamon"
    
    # 🌐 Tunge nettlesere
    "firefox" "chromium" "google-chrome" "opera" "vivaldi"
    "seamonkey" "palemoon" "icecat"
    
    # 📺 Multimedia (hvis ikke kritisk)
    "vlc" "mplayer" "kodi" "totem" "banshee" "rhythmbox"
    "audacity" "kdenlive" "openshot" "pitivi"
    "gimp" "inkscape" "blender" "krita"
    
    # 📧 Email-klienter (erstatt med lett alternativ)
    "thunderbird" "evolution" "kmail"
    
    # 🗂️ Office-suiter
    "libreoffice" "openoffice" "calligra" "abiword" "gnumeric"
    
    # 🎮 Spill
    "supertux" "frozen-bubble" "gnome-games" "kde-games"
    
    # 🌍 Språkpakker (behold kun engelsk)
    "language_pack_" "langpack_" "locale_" "l10n-"
    "firefox-locale-" "libreoffice-l10n" "kde-l10n" "aspell-"
    "hunspell-" "myspell-" "hyphen-"
    
    # 📚 Dokumentasjon (hvis ikke kritisk)
    "manpages-" "doc-" "-doc" "-docs" "texlive-doc"
    
    # 🛠️ Utviklerverktøy (ikke nødvendig for sluttbruker)
    "gcc" "g++" "make" "cmake" "autoconf" "automake"
    "build-essential" "linux-headers" "kernel-devel"
    
    # 🖨️ Printere (hvis ikke nødvendig)
    "cups" "hplip" "gutenprint" "foomatic"
)

# 📦 Pakker som SKAL beholdes (kritiske)
KEEP_PACKAGES=(
    # 🖥️ Lett skrivebord
    "lxde" "openbox" "pcmanfm" "lxterminal" "lxpanel" "lxappearance"
    "jwm" "icewm"
    
    # 🌐 Lett nettleser
    "netsurf" "dillo" "links2" "w3m"
    
    # 🛠️ Grunnleggende utils
    "busybox" "coreutils" "util-linux" "bash" "dash"
    "ncurses" "readline" "zlib" "bzip2" "xz" "gzip"
    
    # 🎨 X.org minimal
    "xorg-server" "xorg-minimal" "xvesa" "xfbdev"
    "xterm" "rxvt" "urxvt"
    
    # 📁 Filhåndtering
    "rox-filer" "thunar-light" "midnight-commander" "ranger"
    
    # 🌐 Nettverk
    "dhcpcd" "wpa_supplicant" "iw" "wireless-tools"
    "network-manager-minimal" "connman"
    
    # 📝 Teksteditor
    "nano" "vim-tiny" "leafpad" "geany-light" "mousepad"
    
    # 🖼️ Bildevisere (lett)
    "feh" "gpicview" "viewnior"
    
    # 📦 Pakkehåndtering
    "petget" "gslapt" "ppm" "pkg"
)

# 🔧 Funksjon for å disable pakke
disable_package() {
    local pkg="$1"
    local file="$2"
    
    # Sjekk om pakken er i KEEP_PACKAGES
    for keep_pkg in "${KEEP_PACKAGES[@]}"; do
        if [[ "$pkg" == "$keep_pkg"* ]]; then
            return 0  # Skip, denne skal beholdes
        fi
    done
    
    # Disable pakken
    if grep -q "^yes|${pkg}|" "$file" 2>/dev/null; then
        sed -i "s/^yes|${pkg}|/no|${pkg}|/" "$file"
        log_info "Disabled: $pkg"
        return 0
    fi
    
    return 1
}

# ✂️ Trim alle specs-filer
for specs_file in "${SPECS_FILES[@]}"; do
    log_info "Prosesserer: $(basename "$specs_file")"
    
    # Backup original
    cp "$specs_file" "${specs_file}.backup"
    
    DISABLED_COUNT=0
    
    # Disable alle REMOVE_PACKAGES
    for pkg_pattern in "${REMOVE_PACKAGES[@]}"; do
        while IFS= read -r line; do
            if [[ "$line" =~ ^yes\|([^|]+)\| ]]; then
                pkg_name="${BASH_REMATCH[1]}"
                if [[ "$pkg_name" == *"$pkg_pattern"* ]]; then
                    if disable_package "$pkg_name" "$specs_file"; then
                        ((DISABLED_COUNT++))
                    fi
                fi
            fi
        done < "$specs_file"
    done
    
    log_success "Disabled $DISABLED_COUNT pakker i $(basename "$specs_file")"
done

# 📝 Opprett/oppdater DISTRO_SPECS
log_info "Konfigurerer DISTRO_SPECS..."

cat > DISTRO_SPECS.local <<'EOF'
# 😺 Teemo Cat Edition - Distro Specs
DISTRO_NAME='TeemoCat'
DISTRO_VERSION='1.0'
DISTRO_FILE_PREFIX='TeemoCat'
DISTRO_TARGETARCH='x86_64'

# 🖥️ X.org minimal setup
DISTRO_XORG_AUTO='yes'
DISTRO_XORG_MINIMAL='yes'

# 🌐 Nettleser
DISTRO_BROWSER='netsurf'

# 📦 Minimal pakkeliste
DISTRO_PKGS_MINIMAL='yes'

# 🎨 Skrivebord
DISTRO_DESKTOP='lxde'
DISTRO_WM='openbox'

# 🌍 Kun engelsk språk
DISTRO_LOCALE='en_US.UTF-8'
DISTRO_LANG='en_US'

# 🔧 Ekstra optimalisering
DISTRO_DB_SUBNAME='minimal'
DISTRO_TARGETCPU='x86_64'
EOF

log_success "DISTRO_SPECS.local opprettet"

# 🔥 Aggressiv trimming (hvis aktivert)
if [[ "$AGGRESSIVE" == "yes" ]]; then
    log_warning "Aggressiv trimming aktivert - fjerner ekstra komponenter"
    
    # Fjern enda flere pakker
    for specs_file in "${SPECS_FILES[@]}"; do
        # Fjern alle *-dev pakker
        sed -i 's/^yes|\(.*-dev\)|/no|\1|/' "$specs_file"
        
        # Fjern testing/debug pakker
        sed -i 's/^yes|\(.*-dbg\)|/no|\1|/' "$specs_file"
        sed -i 's/^yes|\(.*-test\)|/no|\1|/' "$specs_file"
        
        log_info "Aggressiv trimming på $(basename "$specs_file")"
    done
fi

# 📊 Oppsummering
echo ""
log_success "🎉 Trimming fullført!"
echo ""
log_info "Neste steg: Kjør byggesekvensen for å generere ISO"
echo ""
log_info "Filer endret:"
for specs_file in "${SPECS_FILES[@]}"; do
    echo "  - $(basename "$specs_file")"
done
echo ""
log_info "Backup-filer: *.backup"
echo ""

# 💾 Generer pakkeliste for dokumentasjon
PACKAGE_LIST="${PROFILE_DIR}/../../config/packages.txt"
mkdir -p "$(dirname "$PACKAGE_LIST")"

{
    echo "# 📦 Teemo Cat Edition - Pakkeliste"
    echo "# Generert: $(date)"
    echo ""
    echo "## ✅ Aktiverte pakker:"
    for specs_file in "${SPECS_FILES[@]}"; do
        grep "^yes|" "$specs_file" | cut -d'|' -f2 | sort
    done | sort -u
    
    echo ""
    echo "## ❌ Disabled pakker:"
    for specs_file in "${SPECS_FILES[@]}"; do
        grep "^no|" "$specs_file" | cut -d'|' -f2 | sort
    done | sort -u
} > "$PACKAGE_LIST"

log_success "Pakkeliste generert: $PACKAGE_LIST"
