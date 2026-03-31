{ config, pkgs, username, hostname, ... }:

{
  environment.sessionVariables = {
    DOCKER_HOST = "unix:///run/user/1000/podman/podman.sock";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    # ВОЗВРАЩАЕМ ЭТУ ПЕРЕМЕННУЮ! Без неё Hyprland и игры задыхаются
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    NVD_BACKEND = "direct";

    XCURSOR_THEME = "Adwaita"; 
    XCURSOR_SIZE = "24";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_MENU_PREFIX = "plasma-";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    
    EDITOR = "micro";
    TERMINAL = "alacritty";

    PATH = [
      "$HOME/.commands"
      "$HOME/.scripts"
    ];

    XDG_DATA_DIRS = [
      "$HOME/.applications"
    ];
  };
}
