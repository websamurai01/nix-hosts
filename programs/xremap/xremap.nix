{ ... }:

{
  flake.nixosModules.xremap = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.xremap ];

    hm.link.".config/xremap" = ./.config/xremap;
  };
}
