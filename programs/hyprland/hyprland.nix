{ ... }:

{
  flake.nixosModules.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };

      environment.systemPackages = with pkgs; [
        hyprshot
        hyprpicker
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
        config = {
          common.default = [ "kde" ];
          hyprland.default = [ "hyprland" "kde" ];
        };
      };

      hm.link.".config/hypr" = ./.config/hypr;
    };
}
