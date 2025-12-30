{ ... }:

{

  imports = [

    # System
    ./system.nix

    # Home Manager
    ./modules/home-manager.nix

    # Modules
    ./modules/boot.nix
    ./modules/environment.nix
    ./modules/user.nix

    ./modules/hardware.nix
    ./modules/nvidia.nix

    ./modules/networking.nix
    ./modules/bluetooth.nix
    ./modules/virtualization.nix

    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/games.nix

    # Services
    # ./services/system/keyd.nix
    ./services/tailscale.nix
    ./services/mympd.nix

    # Scripts
    ../common/scripts/tilde-stow.nix
    ../common/scripts/nrs.nix
    ../common/scripts/ns.nix
    ../common/scripts/nt.nix
  ];

}
