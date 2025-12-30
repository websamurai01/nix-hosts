{ pkgs, inputs, ... }:

{

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.dconf.enable = true;

  programs.thunar.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-hyprland
      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
    config = {
      common = {
        default = [ "kde" ];
      };
      hyprland = {
        default = [ "hyprland" "kde" ];
      };
    };
  };

}
