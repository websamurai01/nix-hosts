#!/usr/bin/env bash

# Папка для сохранения
DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

# Уведомление о начале (опционально)
# notify-send "Screenshot" "Select area..."

# Выбор режима на основе аргумента
case "$1" in
    "region")
        # Выделение области
        hyprshot -m region -o "$DIR"
        ;;
    "window")
        # Активное окно
        hyprshot -m window -o "$DIR"
        ;;
    "output")
        # Весь монитор
        hyprshot -m output -o "$DIR"
        ;;
    *)
        # По умолчанию (если аргумент не передан)
        hyprshot -m region -o "$DIR"
        ;;
esac
