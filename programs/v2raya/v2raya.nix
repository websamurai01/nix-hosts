{ ... }:

{
  flake.nixosModules.v2raya =
    { pkgs, ... }:
    {
      services.v2raya.enable = true;

      systemd.services.v2raya.path = pkgs.lib.mkForce (with pkgs; [
        iptables
        bash
        iproute2
        xray
      ]);
    };
}
