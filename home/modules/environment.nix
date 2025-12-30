{ config, pkgs, username, hostname, ... }:

{

  # environment.loginShellInit = ''
  #   if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  #      exec uwsm start default
  #   fi
  # '';

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    
    XCURSOR_THEME = "Adwaita"; 
    XCURSOR_SIZE = "24";

    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_MENU_PREFIX = "plasma-";
    GTK_USE_PORTAL = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    
    EDITOR = "nvim";

    PATH = [
      "$HOME/.commands"
      "$HOME/.scripts"
    ];

    XDG_DATA_DIRS = [
      "$HOME/.applications"
    ];

  };

}
