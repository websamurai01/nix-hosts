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

  # --- Fix for System Lag (Dirty Pages for SSD) ---
  # Заставляем ядро сбрасывать данные на SSD маленькими порциями (64 МБ), 
  # не дожидаясь накопления гигантских объемов. Это предотвращает статтеры UI.
  boot.kernel.sysctl = {
    "vm.dirty_background_bytes" = "67108864";
    "vm.dirty_bytes" = "268435456";
  };

}
