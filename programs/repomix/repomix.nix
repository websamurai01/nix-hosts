{ ... }:

{
  flake.nixosModules.repomix = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.repomix ];

    hm.link.".config/repomix" = ./.config/repomix;
  };
}
