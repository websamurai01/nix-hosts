{ config, pkgs, inputs, ... }:

{
  hardware.graphics = {
    enable = true;
    # КРИТИЧЕСКИ ВАЖНО: Включаем 32-битные библиотеки для Steam
    enable32Bit = true; 
    
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
    # Добавляем 32-битные драйверы, если они потребуются играм
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia-container-toolkit.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    
    # ОТКЛЮЧАЕМ экспериментальное управление питанием. 
    # Именно оно не дает видеокарте поднять частоты в CS2.
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    
    open = false;
    nvidiaSettings = true;
    
    # Beta драйвер нужен для Explicit Sync (чтобы в CS2 не было инпут-лага)
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
