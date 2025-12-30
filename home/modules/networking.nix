{ config, pkgs, username, hostname, ... }:

{

  networking = {
    hostName = hostname;
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
    firewall.allowedTCPPorts = [ 80 8080 6600 ];
  };

}
