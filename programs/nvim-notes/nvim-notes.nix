{ ... }:

{
  flake.nixosModules.nvim-notes = { ... }: {
    hm.link.".config/nvim-notes" = ./.config/nvim-notes;
  };
}
