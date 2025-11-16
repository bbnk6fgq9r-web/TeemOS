# 📝 Changelog

All notable changes to Teemo Cat Edition will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned
- GitHub Actions CI/CD workflow
- Docker-based build system
- Multi-arch support (x86_64, i386, ARM)
- Custom kernel configuration
- Pre-built ISO releases

---

## [1.0.0] - 2025-11-16

### Added
- 🎉 Initial release of Teemo Cat Edition
- 🏗️ Complete woof-CE build pipeline automation
- 📦 Minimal package selection (< 900 MB target)
- 🖥️ LXDE/Openbox desktop environment
- 🌐 NetSurf lightweight browser
- ✂️ Automated package trimming script
- 💾 USB flash script with verification
- 📄 Comprehensive documentation:
  - README.md with quick start
  - GETTING-STARTED.md for detailed setup
  - TRIMMING.md for package optimization
  - DEVELOPMENT.md for contributors
- 🛠️ Configuration system:
  - `config/teemocat.conf` for build parameters
  - `config/packages.txt` for package management
- 😺 GitHub Copilot integration via `.github/copilot.yml`
- 📁 Organized project structure

### Features
- **Base Profile:** Slacko64 (Slackware-based)
- **Desktop:** LXDE + Openbox
- **Browser:** NetSurf (primary), Dillo (fallback)
- **Target Size:** 300-900 MB
- **Boot:** Syslinux with UEFI + Legacy support
- **Locale:** English-only (minimal)
- **Compression:** XZ level 9 (maximum)

### Scripts
- `scripts/build-teemocat.sh` - Main build automation
- `scripts/trim-profile.sh` - Package trimming
- `scripts/flash-usb.sh` - USB creation tool

### Documentation
- Quick start guide
- Step-by-step build instructions
- Package trimming strategies
- Development workflow
- Troubleshooting tips

---

## [0.1.0] - 2025-11-10 (Pre-release)

### Added
- Initial project structure
- Basic build scripts (manual)
- Proof-of-concept ISO

### Known Issues
- Manual trimming required
- No automated testing
- Limited documentation

---

## Version History

### Legend
- **Added** - New features
- **Changed** - Changes to existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security updates

---

## Upgrade Notes

### From 0.1.0 to 1.0.0

**Breaking Changes:**
- Complete rewrite of build system
- New configuration format in `config/teemocat.conf`
- Scripts moved to `scripts/` directory

**Migration Steps:**
1. Backup existing builds
2. Clone new version
3. Update configuration files
4. Rebuild from scratch

**New Requirements:**
- woof-CE updated to latest
- Additional dependencies (see `docs/GETTING-STARTED.md`)

---

## Future Roadmap

### v1.1.0 (Planned)
- [ ] Alpine Linux base profile support
- [ ] Custom branding and theming
- [ ] Additional browser options (Pale Moon)
- [ ] Persistence mode for USB
- [ ] Package repository integration

### v1.2.0 (Planned)
- [ ] Multi-language support (opt-in)
- [ ] Hardware detection improvements
- [ ] WiFi setup wizard
- [ ] Live CD performance optimizations

### v2.0.0 (Future)
- [ ] Wayland support
- [ ] ARM architecture builds
- [ ] Custom package manager
- [ ] Cloud build service

---

## Links

- **Releases:** [GitHub Releases](https://github.com/bbnk6fgq9r-web/TeemOS/releases)
- **Issues:** [GitHub Issues](https://github.com/bbnk6fgq9r-web/TeemOS/issues)
- **Discussions:** [GitHub Discussions](https://github.com/bbnk6fgq9r-web/TeemOS/discussions)

---

**Maintained by the Teemo Cat Edition team 😺**
