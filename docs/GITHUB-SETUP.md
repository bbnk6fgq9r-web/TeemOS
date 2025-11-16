# 🚀 Slik pusher du til GitHub og bygger ISO

## Steg 1: Opprett GitHub repo

1. Gå til https://github.com/new
2. **Repository name:** `TeemOS`
3. **Description:** `Minimal Puppy Linux ISO (Teemo Cat Edition)`
4. Velg **Public** (gratis Actions)
5. **IKKE** velg "Add README" (du har allerede en)
6. Klikk **Create repository**

## Steg 2: Push koden

Kjør dette i PowerShell:

```powershell
cd D:\TeemOS

# Initialiser git
git init
git add .
git commit -m "feat: Initial Teemo Cat Edition setup with automated builds"

# Legg til GitHub repo
git remote add origin https://github.com/bbnk6fgq9r-web/TeemOS.git

# Push (første gang)
git branch -M main
git push -u origin main
```

**Første gang du pusher:**
- Git vil spørre om brukernavn/passord
- Bruk Personal Access Token som passord (ikke GitHub-passordet ditt)
- Lag token her: https://github.com/settings/tokens

## Steg 3: Start bygget

1. Gå til GitHub-repoet ditt
2. Klikk **Actions** tab
3. Velg **Build Teemo Cat Edition ISO**
4. Klikk **Run workflow** (høyre side)
5. Velg:
   - **Branch:** main
   - **Aggressive trimming:** no (eller yes for <500 MB ISO)
6. Klikk grønn **Run workflow** knapp

## Steg 4: Vent på bygg (30-60 min)

Du vil se:
- ✅ Grønne haker når steg fullføres
- ⏳ Gult spinner når det bygger
- ❌ Rødt X hvis noe feiler

## Steg 5: Last ned ISO

Når bygget er ferdig:

1. Scroll ned på Actions-siden
2. Finn **Artifacts** seksjonen (nederst)
3. Klikk **TeemoCat-ISO** for å laste ned (ZIP-fil)
4. Pakk ut ZIP-en
5. Du har nå `TeemoCat-<commit>.iso` klar til bruk!

## 📊 Hva skjer under bygget?

GitHub kjører automatisk:
```
1. 📥 Installerer Linux-verktøy
2. 🐾 Kloner woof-CE
3. ✂️ Trimmer pakker
4. 🏗️ Bygger ISO (4 steg)
5. 📤 Laster opp ferdig ISO
```

## 💾 Flash ISO til USB (etter nedlasting)

### Windows:
1. Last ned Rufus: https://rufus.ie
2. Velg USB-disk
3. Velg nedlastet ISO
4. Klikk **START**

### Linux/Mac:
```bash
sudo dd if=TeemoCat.iso of=/dev/sdX bs=4M status=progress
```

## 🔄 Bygg ny versjon

Hver gang du endrer noe og pusher:

```powershell
cd D:\TeemOS
# Gjør endringer...
git add .
git commit -m "feat: Add new feature"
git push
```

GitHub vil automatisk bygge ny ISO! 🎉

## ⚙️ Tilpass bygget

Rediger filer lokalt og push:

```powershell
# Endre konfigurasjon
notepad config\teemocat.conf

# Endre pakker
notepad config\packages.txt

# Push endringer
git add .
git commit -m "config: Update package selection"
git push
```

## 🐛 Hvis bygget feiler

1. Klikk på det røde ❌
2. Klikk på steget som feilet
3. Les error-meldingen
4. Fix problemet lokalt
5. Push igjen

## ❓ Spørsmål?

- Se build logs i GitHub Actions
- Åpne issue på GitHub
- Sjekk `docs/WINDOWS-BUILD.md`

---

**Gratulerer! Du bygger nå Puppy Linux i skyen! 😺☁️**
