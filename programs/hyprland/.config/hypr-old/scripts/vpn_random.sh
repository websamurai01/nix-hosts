#!/bin/bash

# ПУТЬ К ПАПКЕ С КОНФИГАМИ (меняй на свой!)
# Если папка лежит в домашней директории, используй $HOME
VPN_DIR="$HOME/awgvpn"

# Файл, где будем хранить имя текущего активного конфига
STATE_FILE="/tmp/current_active_vpn"

function disconnect_vpn() {
    if [ -f "$STATE_FILE" ]; then
        OLD_CONF=$(cat "$STATE_FILE")
        notify-send "VPN" "Отключаю $OLD_CONF..."
        sudo awg-quick down "$OLD_CONF"
        rm "$STATE_FILE"
    else
        # На случай, если файла нет, но интерфейсы висят - пытаемся отключить всё, что найдем в папке
        # (Опционально, можно убрать этот блок, если боишься лишнего)
        for conf in "$VPN_DIR"/*.conf; do
            sudo awg-quick down "$conf" 2>/dev/null
        done
    fi
}

case "$1" in
    "up")
        # 1. Сначала отключаем старый
        disconnect_vpn
        
        # 2. Выбираем случайный .conf файл
        RANDOM_CONF=$(find "$VPN_DIR" -name "*.conf" | shuf -n 1)

        if [ -z "$RANDOM_CONF" ]; then
            notify-send "VPN Error" "Конфиги не найдены в $VPN_DIR"
            exit 1
        fi

        # 3. Подключаем
        NAME=$(basename "$RANDOM_CONF")
        notify-send "VPN" "Подключаю $NAME..."
        
        if sudo awg-quick up "$RANDOM_CONF"; then
            echo "$RANDOM_CONF" > "$STATE_FILE"
            notify-send "VPN" "Успешно: $NAME"
        else
            notify-send "VPN Error" "Не удалось подключить $NAME"
        fi
        ;;
        
    "down")
        disconnect_vpn
        notify-send "VPN" "VPN полностью отключен"
        ;;
esac
