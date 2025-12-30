{ config, pkgs, inputs, username, ... }:

{
  
  services.getty.autologinUser = "${username}";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel"  "input" "uinput" ];
    shell = pkgs.bash; 
    autoSubUidGidRange = true;
  };

  security.sudo.extraRules = [
    {
      users = [ "${username}" ];
      commands = [
        { 
          command = "/run/current-system/sw/bin/killall";
          options = [ "NOPASSWD" ];
        }
        { 
          command = "/run/current-system/sw/bin/awg-quick";
          options = [ "NOPASSWD" ];
        }
        { 
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

}
