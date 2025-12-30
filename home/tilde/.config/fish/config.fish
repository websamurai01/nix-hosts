# === Qwen CLI ===
# Путь к глобальным npm-пакетам
set -gx PATH ~/.npm-global/bin $PATH

# Твой API-ключ от ModelScope
set -gx MODELSCOPE_API_KEY ms-93b44e83-aa5b-4f1c-a092-3605823f69c5
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# opencode
fish_add_path /home/hash/.opencode/bin

alias awgd='sudo killall amneziawg-go'
alias awgr='sudo killall amneziawg-go & sudo awg-quick up $(find $HOME/VPN/awg/*.conf | shuf -n 1)'
