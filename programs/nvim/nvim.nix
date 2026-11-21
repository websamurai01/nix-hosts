{ ... }:

{
  flake.nixosModules.nvim = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.neovim ];

    hm.link.".config/nvim" = ./.config/nvim;
  };
}
