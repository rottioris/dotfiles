#!/bin/bash

set -euo pipefail

# Colores para terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

ALL_CONFIGS=("fastfetch" "fish" "i3" "kitty")

if [ "$#" -gt 0 ]; then
    CONFIGS=("$@")
else
    CONFIGS=("${ALL_CONFIGS[@]}")
fi

REQUIRED_PROGRAMS=(btop ranger kitty fish fastfetch picom cava cmatrix)

function ask_install() {
    while true; do
        read -rp "$1 (s/n): " yn
        case $yn in
            [Ss]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Por favor responde s (sí) o n (no).";;
        esac
    done
}

function check_and_install() {
    local prog=$1

    if ! command -v "$prog" &>/dev/null; then
        echo -e "${YELLOW}⚠️  No se encontró '$prog' instalado.${NC}"
        if ask_install "¿Quieres instalar '$prog' ahora?"; then
            echo -e "${GREEN}Instalando $prog...${NC}"
            sudo pacman -S --noconfirm "$prog"
            echo -e "${GREEN}$prog instalado.${NC}"
        else
            echo -e "${RED}Aviso: '$prog' no instalado. Algunas funcionalidades pueden fallar.${NC}"
        fi
    else
        echo -e "${GREEN}✔ $prog está instalado.${NC}"
    fi
}

echo -e "${GREEN}🔧 Instalador de dotfiles iniciado.${NC}"
echo "Directorio repo: $REPO_DIR"
echo "Configuraciones a instalar: ${CONFIGS[*]}"
echo ""

# Primero verificamos programas
for prog in "${REQUIRED_PROGRAMS[@]}"; do
    check_and_install "$prog"
done

echo ""

for ITEM in "${CONFIGS[@]}"; do
    SRC="$REPO_DIR/$ITEM"
    DEST="$CONFIG_DIR/$ITEM"

    if [ ! -d "$SRC" ]; then
        echo -e "${YELLOW}⚠️  Carpeta '$ITEM' no encontrada en el repositorio. Saltando.${NC}"
        continue
    fi

    echo -e "${GREEN}📁 Instalando $ITEM...${NC}"

    if [ -e "$DEST" ] && [ ! -L "$DEST" ]; then
        BACKUP="$DEST.backup.$(date +%Y%m%d%H%M%S)"
        mv "$DEST" "$BACKUP"
        echo -e "${YELLOW}🗂️  Copia de seguridad creada en $BACKUP${NC}"
    fi

    if [ -L "$DEST" ] || [ -d "$DEST" ] || [ -f "$DEST" ]; then
        rm -rf "$DEST"
    fi

    mkdir -p "$(dirname "$DEST")"
    ln -sf "$SRC" "$DEST"
    echo -e "${GREEN}✅ $ITEM vinculado con symlink.${NC}"
done

# Instalar wallpaper personalizado
echo ""
echo -e "${GREEN}🖼️ Instalando fondo de pantalla personalizado...${NC}"

WALL_SRC="$REPO_DIR/.config/wallpapers/1353199.png"
WALL_DEST="/usr/share/endeavouros/backgrounds/1353199.png"

if [ -f "$WALL_SRC" ]; then
    echo "→ Copiando $WALL_SRC a $WALL_DEST"
    sudo cp "$WALL_SRC" "$WALL_DEST"
    echo -e "${GREEN}✔️  Wallpaper instalado correctamente.${NC}"
else
    echo -e "${YELLOW}⚠️  No se encontró el archivo: $WALL_SRC. Saltando copia del fondo.${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Instalación completada.${NC}"
echo "Revisa ~/.config para verificar los symlinks creados."
echo "Si quieres deshacer la instalación, elimina los symlinks y restaura backups si es necesario."
