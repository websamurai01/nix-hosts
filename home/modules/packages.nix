{ pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [

    # System
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
    xorg.xhost
    pulseaudio
    gnome-disk-utility
    bluez
    blueman
    sshfs

    # Desktop
    fuzzel
    quickshell
    mako
    libnotify
    swww
    xremap
    hyprshot
    hyprpicker
    wlsunset
    wl-clipboard
    peazip
    bitwarden-desktop
    qwen-code

    # Terminal Programs
    foot
    kitty
    neovim
    btop
    yazi
    ripdrag

    # Virtualization
    distrobox
    runc
    crun

    # CLI Programs
    repomix

    # Rust Utils
    ripgrep
    bat
    fd
    fzf

    # Media
    mpv
    imv
    mpc
    rmpc
    flac
    flac2all
    mediainfo
    qbittorrent
    transmission_4
    
    # Network
    amneziawg-go
    amneziawg-tools

    # Web
    ungoogled-chromium
    ayugram-desktop

    # Themes and Icons
    nwg-look
    adwaita-icon-theme
    papirus-icon-theme
    dconf
    libsForQt5.qt5ct
    kdePackages.qt6ct
    kdePackages.xdg-desktop-portal-kde
    
    # Flake Inputs
    inputs.zen-browser.packages.x86_64-linux.default
    inputs.photogimp.packages.${pkgs.system}.default
  ];

}
