{ config, pkgs, inputs, ... }:

{
  
  # --- Bluetooth ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Включаем поддержку отображения заряда батареи наушников
        Experimental = true;
        
        # Принудительно используем классический Bluetooth для аудио
        ControllerMode = "bredr";
      };
    };
  };

  services.blueman.enable = true;

}
