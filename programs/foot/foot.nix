{ ... }:

{
  flake.nixosModules.foot = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.foot ];

    hm.link.".config/foot" = ./.config/foot;
  };
}
