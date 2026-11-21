#!/bin/bash

# Проверяем активное VPN-соединение
ACTIVE_VPN=$(nmcli -t -f NAME,TYPE,STATE con show --active | grep 'vpn:activated' | awk -F: '{print $1}' | head -n 1)
if [ ! -z "$ACTIVE_VPN" ]; then
    # Если VPN активно: показываем его имя
    echo "{\"text\":\"🛡️ $ACTIVE_VPN\",\"tooltip\":\"Активный VPN\"}"
# ...
else
    # Если VPN неактивно: показываем реальную страну и IP
    INFO=$(curl -s ipinfo.io/json)
    # Убедимся, что curl вернул данные, иначе выводим '--'
    if [ -z "$INFO" ]; then
        echo "{\"text\":\"🌐 Offline\",\"tooltip\":\"Нет подключения к сети\"}"
    else
        IP=$(echo "$INFO" | jq -r '.ip')
        COUNTRY=$(echo "$INFO" | jq -r '.country')
        echo "{\"text\":\"🌐 $COUNTRY ($IP)\",\"tooltip\":\"Ваш реальный IP и страна\"}"
    fi
fi
