{ ... }:

{
  flake.nixosModules.mimeapps = { ... }: {
    hm.link.".config/mimeapps.list" = ./.config/mimeapps.list;
  };
}
