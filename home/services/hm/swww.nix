{ pkgs, ... }:

{

  # --- SWWW Wallpaper Daemon ---
  systemd.user.services.swww = {
    Unit = {
      Description = "Wayland Wallpaper Daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
      RestartSec = 1;
      Type = "simple";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

}
