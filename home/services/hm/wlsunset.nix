{ pkgs, ... }:

{

  # --- Wlsunset ---
  systemd.user.services.wlsunset = {
    Unit = {
      Description = "Day/Night Gamma Adjuster";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wlsunset}/bin/wlsunset -S 08:00 -s 21:00 -d 3600 -t 4000";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

}
