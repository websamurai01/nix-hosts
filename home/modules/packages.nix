{ pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [

    # System
    polkit_gnome
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
    xorg.xhost
	pwvucontrol
    gnome-disk-utility
    bluez
    blueman
    sshfs
    veracrypt
    uv

    #Devs
    obsidian
    vscodium
    yt-dlp
    ffmpeg


  
	# Social
	ayugram-desktop
	discord
	
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

    #Gaming
    steam

    # Terminal Programs
    neofetch
    alacritty
    waybar
    micro
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
    qbittorrent
    
    # Network
    amneziawg-go
    amneziawg-tools

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
    
    # Flake Inputs
    # inputs.zen-browser.packages.x86_64-linux.default
    # inputs.photogimp.packages.${pkgs.system}.default
  ];

}
