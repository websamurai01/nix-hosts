{ pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [
    lutris
    luanti
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

}
