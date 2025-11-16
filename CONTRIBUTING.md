# 🤝 Contributing to Teemo Cat Edition

Thank you for your interest in contributing! 😺

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Style Guidelines](#style-guidelines)
- [Testing](#testing)
- [Documentation](#documentation)
- [Community](#community)

---

## 🌟 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for everyone.

### Our Standards

**✅ Positive behavior:**
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Accepting constructive criticism gracefully
- Focusing on what's best for the community
- Showing empathy towards others

**❌ Unacceptable behavior:**
- Trolling, insulting, or derogatory comments
- Public or private harassment
- Publishing others' private information
- Unprofessional conduct

### Enforcement

Violations can be reported to the project maintainers. All reports will be reviewed and investigated.

---

## 🚀 Getting Started

### Prerequisites

1. **Fork the repository** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/TeemOS.git
   cd TeemOS
   ```
3. **Add upstream remote:**
   ```bash
   git remote add upstream https://github.com/<your-org>/TeemOS.git
   ```
4. **Install dependencies:**
   ```bash
   sudo apt install git build-essential squashfs-tools xorriso shellcheck
   ```

### First Build

```bash
chmod +x scripts/*.sh
./scripts/build-teemocat.sh
```

---

## 🛠️ How to Contribute

### Types of Contributions

#### 🐛 Bug Reports

Found a bug? Please [open an issue](https://github.com/<your-org>/TeemOS/issues/new) with:
- Clear title
- Detailed description
- Steps to reproduce
- Expected vs actual behavior
- System information (OS, version, etc.)
- Screenshots/logs if applicable

#### 💡 Feature Requests

Have an idea? [Open a feature request](https://github.com/<your-org>/TeemOS/issues/new) with:
- Clear use case
- Detailed description
- Why it's valuable
- Proposed implementation (optional)

#### 📝 Documentation

Improvements to documentation are always welcome:
- Fix typos or clarifications
- Add examples
- Translate documentation
- Write tutorials

#### 💻 Code Contributions

See [Development Workflow](#development-workflow) below.

---

## 🔄 Development Workflow

### 1. Create a Branch

```bash
git checkout -b feature/my-awesome-feature
# or
git checkout -b fix/issue-123
```

**Branch naming conventions:**
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation only
- `refactor/` - Code refactoring
- `test/` - Test additions/changes
- `chore/` - Maintenance tasks

### 2. Make Changes

```bash
# Edit files
nano scripts/build-teemocat.sh

# Test your changes
shellcheck scripts/*.sh
./scripts/build-teemocat.sh
```

### 3. Commit Changes

Use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git add .
git commit -m "feat: Add Alpine Linux base profile support"
```

**Commit message format:**
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting (no code change)
- `refactor:` Code restructuring
- `test:` Adding tests
- `chore:` Maintenance

**Examples:**
```
feat(build): Add parallel compression support
fix(trim): Correct package dependency check
docs(readme): Update installation instructions
```

### 4. Push and PR

```bash
# Push to your fork
git push origin feature/my-awesome-feature

# Open Pull Request on GitHub
```

**PR Guidelines:**
- Clear title and description
- Link related issues (`Fixes #123`)
- Include screenshots/logs if applicable
- Update documentation if needed
- Ensure all tests pass

---

## 📏 Style Guidelines

### Bash Scripts

**Header:**
```bash
#!/usr/bin/env bash
# 🏗️ Script Title
# Brief description

set -euo pipefail
```

**Functions:**
```bash
# 📦 Function description
function_name() {
    local param1="$1"
    local param2="${2:-default}"
    
    # Implementation
}
```

**Error Handling:**
```bash
if [[ ! -f "$FILE" ]]; then
    log_error "File not found: $FILE"
fi
```

**Naming:**
- Variables: `UPPER_CASE` for constants, `lower_case` for locals
- Functions: `snake_case`
- Use descriptive names

**Validation:**
```bash
# Run shellcheck before committing
shellcheck scripts/*.sh

# Format with shfmt (optional)
shfmt -w scripts/*.sh
```

### Markdown

- Use emoji prefixes in headings (📦, 🚀, etc.)
- Fenced code blocks with language tags
- Inline code for: `files`, `commands`, `variables`
- Keep lines ≤ 100 characters (soft limit)

### Configuration Files

- Use comments to explain non-obvious settings
- Group related settings together
- Include examples for complex options

---

## 🧪 Testing

### Before Submitting PR

**1. Script validation:**
```bash
shellcheck scripts/*.sh
bash -n scripts/*.sh
```

**2. Build test:**
```bash
./scripts/build-teemocat.sh
ls -lh woof-output/TeemoCat.iso
```

**3. ISO validation:**
```bash
# Test in QEMU
qemu-system-x86_64 -cdrom woof-output/TeemoCat.iso -m 2G

# Check size
SIZE=$(stat -c%s woof-output/TeemoCat.iso)
SIZE_MB=$((SIZE / 1024 / 1024))
if [[ $SIZE_MB -gt 900 ]]; then
    echo "Warning: ISO exceeds 900 MB target"
fi
```

**4. Documentation:**
```bash
# Verify links
markdown-link-check README.md

# Spell check (if available)
aspell check docs/*.md
```

---

## 📚 Documentation

### What to Document

- New features and how to use them
- Configuration options and their effects
- Breaking changes and migration guides
- Troubleshooting tips
- Examples and use cases

### Where to Add Documentation

- `README.md` - Quick start and overview
- `docs/GETTING-STARTED.md` - Detailed setup
- `docs/TRIMMING.md` - Package management
- `docs/DEVELOPMENT.md` - Developer guide
- `CHANGELOG.md` - Version history

### Documentation Standards

- Use clear, concise language
- Include code examples
- Add screenshots for UI changes
- Keep documentation up-to-date with code

---

## 💬 Community

### Get Help

- **Issues:** [GitHub Issues](https://github.com/bbnk6fgq9r-web/TeemOS/issues)
- **Discussions:** [GitHub Discussions](https://github.com/bbnk6fgq9r-web/TeemOS/discussions)
- **Forum:** [Puppy Linux Community](https://forum.puppylinux.com)

### Stay Updated

- **Watch** the repository for notifications
- **Star** the repository to show support
- **Follow** releases for new versions

---

## 🏆 Recognition

Contributors are recognized in:
- `CHANGELOG.md` (for significant contributions)
- GitHub contributors page
- Release notes

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT for scripts/docs, GPL-2.0 for ISO components).

See [LICENSE](LICENSE) for details.

---

## ❓ Questions?

Feel free to ask questions in:
- [GitHub Discussions](https://github.com/bbnk6fgq9r-web/TeemOS/discussions)
- Issue comments
- Pull request comments

We're here to help! 😺

---

**Thank you for contributing to Teemo Cat Edition!**
