{ pkgs, lib, username, config, ... }:

let
  wrapper = config.my.chromium.wrapper;
in
{
  home-manager.users.${username} = {
    systemd.user.services.chromium-service = {
      Unit = {
        Description = "Chromium Background Service";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        # Using the wrapper is cleaner here too
        ExecStart = "${wrapper}/bin/chromium-browser --silent-launch";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "XDG_CURRENT_DESKTOP=Hyprland"
        ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
