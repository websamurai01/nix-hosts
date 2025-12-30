{ config, pkgs, inputs, ... }:

{
  
  # --- Bluetooth ---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        AutoEnable = true;
        Enable = "Source,Sink,Media,Socket";
        AutoConnect = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true;

}
