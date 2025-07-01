#!/bin/bash

# ▒ Carpeta del repositorio de dotfiles
REPO="$HOME/dotfiles/.config"

# ▒ Carpeta donde se guardan backups antes de sobreescribir
BACKUP_DIR="$HOME/dotfiles/.backup"

# ▒ Log del proceso
LOG_FILE="$HOME/dotfiles/sync.log"

# ▒ Configs a sincronizar
CONFIGS=(i3 kitty fastfetch fish)

# ▒ Colores
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

# ▒ Timestamp
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')

# ▒ Crear backup y log si no existen
mkdir -p "$BACKUP_DIR"
touch "$LOG_FILE"

echo -e "${YELLOW}🔄 Iniciando sincronización de dotfiles...${RESET}"
echo "[$TIMESTAMP] === Sincronización iniciada ===" >> "$LOG_FILE"

for cfg in "${CONFIGS[@]}"; do
    SRC="$HOME/.config/$cfg"
    DEST="$REPO/$cfg"

    if [ -d "$SRC" ]; then
        echo -e "${GREEN}✔ Encontrado: $cfg${RESET}"
        echo "[$TIMESTAMP] Copiando $cfg..." >> "$LOG_FILE"

        # ▒ Hacer backup si ya existe en el repo
        if [ -d "$DEST" ]; then
            BACKUP_PATH="$BACKUP_DIR/${cfg}_$TIMESTAMP"
            mv "$DEST" "$BACKUP_PATH"
            echo "[$TIMESTAMP] Backup previo de $cfg → $BACKUP_PATH" >> "$LOG_FILE"
        fi

        # ▒ Copiar configuración al repo
        cp -r "$SRC" "$DEST"
        echo "[$TIMESTAMP] Copiado $cfg a $DEST" >> "$LOG_FILE"
    else
        echo -e "${RED}✖ $cfg no encontrado en ~/.config/, saltando.${RESET}"
        echo "[$TIMESTAMP] $cfg no encontrado, omitido." >> "$LOG_FILE"
    fi
done

echo -e "${GREEN}✅ Sincronización completada.${RESET}"
echo "[$TIMESTAMP] === Sincronización finalizada ===" >> "$LOG_FILE"

# ▒ Notificación final
if command -v notify-send &> /dev/null; then
    notify-send "Dotfiles" "✅ Configs sincronizadas correctamente"
fi
