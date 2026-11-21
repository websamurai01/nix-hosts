{ ... }:

{
  flake.nixosModules.fuzzel = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.fuzzel ];

    hm.link.".config/fuzzel" = ./.config/fuzzel;
  };
}
