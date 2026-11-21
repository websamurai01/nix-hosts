{ ... }:

{
  flake.nixosModules.games =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        lutris
        luanti
      ];

      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
    };
}
