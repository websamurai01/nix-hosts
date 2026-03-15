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

  # --- Kernel Parameters (Запрет сна для Bluetooth/USB) ---
  boot.kernelParams =[ 
    "btusb.enable_autosuspend=0"
    "usbcore.autosuspend=-1" 
  ];

  # --- Fix for System Lag (Dirty Pages) ---
  # Золотая середина: 256 МБ (background) и 512 МБ (limit).
  # Этого с головой хватит играм, чтобы не фризить, 
  # и спасет от зависания ПК при загрузке 100 ГБ файлов на HDD.
  boot.kernel.sysctl = {
    "vm.dirty_background_bytes" = "268435456";
    "vm.dirty_bytes" = "536870912";
  };

}
