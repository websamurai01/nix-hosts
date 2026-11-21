{ ... }:

{
  flake.nixosModules.folders =
    { lib, ... }:
    let
      entries = builtins.readDir ../folders;
    in
    {
      hm.link = lib.mapAttrs' (
        name: _: lib.nameValuePair name (../folders + "/${name}")
      ) entries;
    };
}
