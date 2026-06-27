{ pkgs, inputs, ... }:

{

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.fish.enable = true;
  programs.amnezia-vpn.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.dconf.enable = true;

  programs.thunar.enable = true;

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.v2raya.enable = true;
  	systemd.services.v2raya.path = 
  pkgs.lib.mkForce (with pkgs; [
  	iptables
  	bash
  	iproute2
  	xray
  ]);

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
