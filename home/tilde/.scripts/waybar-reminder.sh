#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/reminders.conf"
SKIP_FILE="/tmp/waybar_reminder_skip"
CURRENT_MODE_FILE="/tmp/waybar_mode"
REMINDER_CONTENT_FILE="/tmp/waybar_reminder.json"

# Пути к конфигам
NORMAL_CONFIG="$HOME/.config/waybar/config"
NORMAL_STYLE="$HOME/.config/waybar/style.css"
ALERT_CONFIG="$HOME/.config/waybar/config-alert.jsonc"
ALERT_STYLE="$HOME/.config/waybar/style-alert.css"

function time_to_minutes() {
    IFS=':' read -r h m <<< "$1"
    echo $((10#$h * 60 + 10#$m))
}

function launch_waybar() {
    local mode=$1
    echo "$mode" > "$CURRENT_MODE_FILE"
    
    # Убиваем старый процесс
    killall waybar
    wait
    
    if [ "$mode" == "alert" ]; then
        waybar -c "$ALERT_CONFIG" -s "$ALERT_STYLE" &
    else
        waybar -c "$NORMAL_CONFIG" -s "$NORMAL_STYLE" &
    fi
}

# Инициализация: считаем, что мы в нормальном режиме
launch_waybar "normal"

while true; do
    current_mins=$(time_to_minutes "$(date +%H:%M)")
    active_event=""
    
    # Читаем конфиг
    if [ -f "$CONFIG_FILE" ]; then
        while IFS=';' read -r event_name times || [ -n "$event_name" ]; do
            # Пропускаем комментарии и пустые строки
            [[ $event_name =~ ^#.*$ ]] || [[ -z $event_name ]] && continue
            
            IFS=',' read -r start_time end_time <<< "$times"
            
            start_mins=$(time_to_minutes "$start_time")
            end_mins=$(time_to_minutes "$end_time")
            
            if (( current_mins >= start_mins && current_mins < end_mins )); then
                # Формируем уникальный ID события (на основе времени и имени)
                event_id=$(echo "${event_name}_${start_time}" | md5sum | cut -d' ' -f1)
                
                # Проверяем, не скипнул ли пользователь это событие
                if [ -f "$SKIP_FILE" ]; then
                    skipped_id=$(cat "$SKIP_FILE")
                    if [ "$skipped_id" == "$event_id" ]; then
                        continue
                    fi
                fi
                
                active_event="$event_name"
                active_time="$start_time - $end_time"
                current_event_id="$event_id"
                break
            fi
        done < "$CONFIG_FILE"
    fi

    current_mode=$(cat "$CURRENT_MODE_FILE" 2>/dev/null)

    if [ -n "$active_event" ]; then
        # Если есть активное событие и мы еще не в режиме тревоги
        if [ "$current_mode" != "alert" ]; then
            # Записываем JSON для модуля
            echo "{\"text\": \"$active_event\", \"alt\": \"$active_time\", \"tooltip\": \"Напишите wayskip в терминале\"}" > "$REMINDER_CONTENT_FILE"
            launch_waybar "alert"
        fi
    else
        # Если событий нет (или они скипнуты), но мы в режиме тревоги -> вернуть все назад
        if [ "$current_mode" == "alert" ]; then
            launch_waybar "normal"
            # Очищаем файл скипа, так как событие закончилось
            rm -f "$SKIP_FILE"
        fi
    fi

    sleep 5
done
