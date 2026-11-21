{ ... }:

{
  networking = {
    hostName = "home";
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
    firewall.allowedTCPPorts = [
      80
      8080
      6600
    ];
  };
}
