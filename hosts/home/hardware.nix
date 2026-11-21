{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };

  boot.kernelParams = [
    "btusb.enable_autosuspend=0"
    "usbcore.autosuspend=-1"
  ];

  boot.kernel.sysctl = {
    "vm.dirty_background_bytes" = "67108864";
    "vm.dirty_bytes" = "268435456";
  };

  programs.fuse.userAllowOther = true;
  programs.ssh.startAgent = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
