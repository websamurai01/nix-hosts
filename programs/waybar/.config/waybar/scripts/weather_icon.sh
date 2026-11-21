#!/bin/bash

# WEATHER SCRIPT FOR WAYBAR (FORMATTED TEMPERATURE ONLY)

LAT=55.75
LON=37.5
API_URL="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current_weather=true"

WEATHER_DATA=$(curl -s "$API_URL")

# Check if data was retrieved
if [ $? -ne 0 ] || [ -z "$WEATHER_DATA" ]; then
    echo '{"text": "N/A"}'
    exit 1
fi

TEMPERATURE=$(echo "$WEATHER_DATA" | jq -r '.current_weather.temperature' 2>/dev/null)

# Fallback check if jq failed to parse keys
if [ -z "$TEMPERATURE" ]; then
    echo '{"text": "N/A"}'
    exit 1
fi

# Format the temperature: one decimal place and degree symbol (°)
TEMPERATURE_FORMATTED=$(printf "%.1f" $TEMPERATURE)

# Output only the formatted temperature
echo "{\"text\":\"${TEMPERATURE_FORMATTED}°\"}"
