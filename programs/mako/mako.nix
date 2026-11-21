{ ... }:

{
  flake.nixosModules.mako = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.mako ];

    hm.link.".config/mako" = ./.config/mako;
  };
}
