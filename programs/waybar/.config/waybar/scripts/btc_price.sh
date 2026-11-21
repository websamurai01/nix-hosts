#!/usr/bin/env bash
# BTC price module for Waybar
# - Smooth output: always prints something, no flicker
# - Uses CoinGecko (no API key)
# - Shows last known price if request fails

API_URL="https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/waybar-btc"
CACHE_FILE="${CACHE_DIR}/btc_price.txt"

mkdir -p "$CACHE_DIR"

fetch_and_cache() {
  # Timeout to avoid hanging Waybar
  RESPONSE=$(curl -sS --max-time 3 "$API_URL")
  if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
    return 1
  fi

  # Extract number using jq if available, otherwise fallback to sed
  if command -v jq &>/dev/null; then
    PRICE=$(printf '%s' "$RESPONSE" | jq -r '.bitcoin.usd // empty')
  else
    PRICE=$(printf '%s' "$RESPONSE" | sed -n 's/.*"usd":\([^}]*\).*/\1/p')
  fi

  # Validate that PRICE is a number
  if ! printf '%s' "$PRICE" | grep -Eq '^[0-9]+(\.[0-9]+)?$'; then
    return 1
  fi

  # Round to 0 decimals (adjust as you like)
  PRICE_INT=$(printf '%.0f\n' "$PRICE")
  echo "$PRICE_INT" > "$CACHE_FILE"
  echo "$PRICE_INT"
  return 0
}

print_cached() {
  if [ -f "$CACHE_FILE" ]; then
    cat "$CACHE_FILE"
    return 0
  fi
  return 1
}

# Try to fetch fresh price; on failure, use cached; on total failure, show placeholder.
if PRICE=$(fetch_and_cache); then
  :
elif PRICE=$(print_cached); then
  :
else
  PRICE="…"
fi

# Final output: stable format, Waybar will not flicker as long as it gets consistent lines.
# Example display: "₿ 96123"
echo "₿ ${PRICE}"
