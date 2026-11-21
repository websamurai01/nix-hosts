{ ... }:

{
  flake.nixosModules.waybar = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.waybar ];

    hm.link.".config/waybar" = ./.config/waybar;

    hm.systemd.user.services.waybar = {
      Unit = {
        Description = "Waybar Status Bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
