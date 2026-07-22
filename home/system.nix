{ config, pkgs, username, hostname, ... }:

{

  # --- Localization ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Fonts Configuration ---
  fonts = {
    enableDefaultPackages = true; # Installs baseline fonts
    
    packages = with pkgs; [
      fixedsys-excelsior
      nerd-fonts.commit-mono
      commit-mono
      noto-fonts                  # Base Latin, Cyrillic, Greek
      noto-fonts-cjk-sans         # Chinese, Japanese, Korean Sans-Serif
      noto-fonts-cjk-serif        # Chinese, Japanese, Korean Serif
      twitter-color-emoji         # Stable vector emoji font for Firefox
    ];

    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        monospace = [ "CommitMono Nerd Font" ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };

  # --- Security ---
  security.polkit.enable = true; 
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

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
