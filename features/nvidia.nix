{ ... }:

{
  flake.nixosModules.nvidia =
    { config, pkgs, ... }:
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          nvidia-vaapi-driver
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          nvidia-vaapi-driver
        ];
      };

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia-container-toolkit.enable = true;

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = false;
        powerManagement.finegrained = false;

        open = false;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };
}
