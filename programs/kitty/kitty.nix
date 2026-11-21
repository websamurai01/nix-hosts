{ ... }:

{
  flake.nixosModules.kitty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.kitty ];

    hm.link.".config/kitty" = ./.config/kitty;
  };
}
