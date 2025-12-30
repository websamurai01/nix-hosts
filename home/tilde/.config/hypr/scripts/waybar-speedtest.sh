#!/bin/bash

notify-send "Speedtest" "⚡ Замер скорости начат..."

# Запускаем speedtest-cli и получаем результат
RESULT=$(speedtest-cli --simple | awk '/Download|Upload/ {printf "%s %s | ", $1, $2}')

notify-send "Speedtest Результат" "$RESULT"

# Выводим результат в Waybar
echo "{\"text\":\"${RESULT% | } \",\"tooltip\":\"Нажмите для повторного замера\"}"
