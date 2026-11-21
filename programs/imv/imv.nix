{ ... }:

{
  flake.nixosModules.imv = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.imv ];

    hm.link.".config/imv" = ./.config/imv;
  };
}
