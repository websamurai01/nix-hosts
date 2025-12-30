{ config, pkgs, inputs, username, ... }:

{

  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = { inherit inputs username; };
    backupFileExtension = "backup"; 
    users.${username} = {
      home.stateVersion = "25.05";
      imports = [
        
        inputs.xremap.homeManagerModules.default

        ./theme.nix
        ../services/hm/mpd.nix
        ../services/hm/swww.nix
        ../services/hm/wlsunset.nix
        ../services/hm/quickshell.nix
        ../services/hm/listenbrainz-mpd-90-no4m.nix
        ../services/hm/xremap.nix
      ];
    };
  };

}
