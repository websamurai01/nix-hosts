# export PATH="$HOME/.commands:$HOME/.scripts:$PATH"

# Programs
alias nv=nvim
alias nvn='NVIM_APPNAME=nvim-notes nvim'

alias clients='hyprctl clients'
alias x+='chmod +x'

alias docker='sudo docker'
alias uvr='env PYTHONDONTWRITEBYTECODE=1 uv run'

# Networking
alias awgd='sudo killall amneziawg-go'
alias awgr='sudo killall amneziawg-go & sudo awg-quick up $(find $HOME/VPN/awg/*.conf | shuf -n 1)'

alias ipcheck='curl ip-api.com/line'

gitsync() {
    # Check if an argument ($1) was passed
    if [ -z "$1" ]; then
        # No argument: set message to current date/time
        msg=$(date -u +"%Y-%m-%d at %H:%M UTC")
    else
        # Argument exists: use it as the message
        msg="$1"
    fi

    # Run git commands
    git add .
    git commit -m "$msg"
    git push -u origin main
    repomix
}
