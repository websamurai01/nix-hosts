{ ... }:

{
  flake.nixosModules.direnv = { ... }: {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
