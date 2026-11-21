{ pkgs, ... }:

{
  programs.amnezia-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    # System
    jdk21
    android-studio
    unrar
    curl
    git
    wget
    stow
    unzip
    gcc
    tree
    killall
    jq
    ydotool
    wtype
    wev
    xhost
    pwvucontrol
    gnome-disk-utility
    bluez
    blueman
    sshfs
    veracrypt
    uv
    throne
    nodejs
    docker

    # Devs
    obsidian
    vscodium
    yt-dlp
    ffmpeg
    python3
    docker-compose

    # Social
    ayugram-desktop
    discord

    # Desktop
    libnotify
    slurp
    grim
    wlsunset
    wl-clipboard
    peazip
    bitwarden-desktop

    # Gaming
    steam

    # Terminal Programs
    fastfetch
    micro
    btop
    yazi
    ripdrag
    lazygit

    # Virtualization
    distrobox
    runc
    crun

    # Rust Utils
    ripgrep
    bat
    fd
    fzf

    # Media
    qbittorrent

    # Network
    amneziawg-go
    amneziawg-tools
    amnezia-vpn

    # Web
    tor-browser
    firefox

    # Themes and Icons
    nwg-look
    adwaita-icon-theme
    papirus-icon-theme
    dconf
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.xdg-desktop-portal-kde
  ];
}
