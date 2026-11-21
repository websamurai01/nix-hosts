{ ... }:

{
  flake.nixosModules.mpv = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mpv ];

    hm.link.".config/mpv" = ./.config/mpv;
  };
}
