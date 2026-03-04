{ config, pkgs, username, hostname, ... }:

{

  # --- Boot ---
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  # --- Fix for System Lag (Dirty Pages) ---
  # Исправлено: добавлена точка между kernel и sysctl
  boot.kernel.sysctl = {
    "vm.dirty_background_bytes" = "16777216";
    "vm.dirty_bytes" = "50331648";
  };

}
