# Snow Bros NeoGeo Port - GitHub Actions Build

## 🚀 Quick Start (2 minutos)

### 1. Crear repo en GitHub
1. Ve a https://github.com/new
2. Nombre: `snowbros-neogeo-port`
3. **Privado** (recomendado)
4. **NO** inicialices con README/license/gitignore
4. Click "Create repository"

### 2. Sube estos archivos (arrastra y suelta en GitHub web)
```
├── .github/workflows/build_snowbros.yml
├── assets/
│   ├── sbros-1.41.full          # C ROM 2MB (copia tuya)
│   ├── snowbros.cue
│   ├── snowbros.bin
│   ├── track01.wav ... track07.wav
```

### 3. Ejecutar Build
1. Ve a **Actions** tab en tu repo
2. Click "Build Snow Bros NeoGeo Port"
3. Click **"Run workflow"** → **Run workflow**
4. Espera **30-40 minutos**
4. En **Artifacts** descarga `mame-snowbros-mvs` (binario MAME compilado)

---

## 📁 Estructura del repo
```
├── .github/workflows/build_snowbros.yml   # CI/CD workflow
├── assets/
│   ├── sbros-1.41.full       # C ROM 2MB (16,384 tiles)
│   ├── snowbros.cue          # CUE sheet
│   ├── snowbros.bin          # Data track 7.4MB
│   ├── track01.wav ... track07.wav  # Audio tracks
```

---

## 🎮 Cómo probar el binario descargado

```bash
# Extraer artifact
unzip mame-snowbros-mvs.zip

# Copiar ROMs necesarias a roms/snowbros_mvs/
mkdir -p roms/snowbros_mvs
cp sbros-1.41 roms/snowbros_mvs/sbros-1.41  # C ROM 2MB

# Probar MVS (driver compilado)
./mame neogeo snowbros_mvs -rompath roms -nvram_directory tmp -window

# O con Lua hook (traduce hardware Pandora→NeoGeo)
./mame neogeo snowbros_mvs -rompath roms -nvram_directory tmp -lua snowbros_pandora2neogeo.lua -window
```

---

## ⚠️ Requisitos previos
- **BIOS NeoGeo CD** (`neocdz.zip` en `roms/neocdz/`) para driver `neocdz`
- **ROMs originales Pandora** (`sn6.bin`, `sn5.bin`, `sbros-4.29`) para driver original `snowbros`

---

## 🎯 Checklist test visual
| Pantalla | ✅ OK | ❌ Fallo |
|----------|-------|----------|
| Attract | 3 colores/sprite | 1 color (naranja) |
| Gameplay | Sprites completos | Naranja sólido |
| Transiciones | Suaves | Glitches |# Trigger workflow
