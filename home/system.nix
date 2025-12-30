{ config, pkgs, username, hostname, ... }:

{

    # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Fonts ---
  fonts.packages = with pkgs; [
    nerd-fonts.commit-mono
    commit-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  programs.fuse.userAllowOther = true;

  programs.ssh.startAgent = true;

  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="uinput", MODE="0660"
    KERNEL=="event*", GROUP="input", MODE="0660"
  '';

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11"; 

}
