{ ... }:

{
  flake.nixosModules.thunar = { ... }: {
    programs.thunar.enable = true;

    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.udisks2.enable = true;

    hm.link = {
      ".config/Thunar" = ./.config/Thunar;
      ".config/xfce4" = ./.config/xfce4;
    };
  };
}
