{ ... }:

{
  flake.nixosModules.alacritty = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.alacritty ];

    hm.link.".config/alacritty" = ./.config/alacritty;
  };
}
