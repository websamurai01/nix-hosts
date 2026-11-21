{ ... }:

{
  flake.nixosModules.quickshell =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.quickshell ];

      hm.link.".config/quickshell" = ./.config/quickshell;

      hm.systemd.user.services.quickshell = {
        Unit = {
          Description = "Quickshell Desktop Shell";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.quickshell}/bin/quickshell -p %h/.config/quickshell/hypr-ref/shell.qml";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
