{ ... }:

{
  flake.nixosModules.uwsm = { ... }: {
    hm.link.".config/uwsm" = ./.config/uwsm;
  };
}
