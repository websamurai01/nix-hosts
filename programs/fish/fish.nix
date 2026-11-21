{ ... }:

{
  flake.nixosModules.fish = { ... }: {
    hm.link.".config/fish" = ./.config/fish;
  };
}
