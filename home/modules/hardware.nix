{ config, lib, pkgs, modulesPath, ... }:

{

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/aace99ed-5d25-4cf6-98a2-631459ae5fa2";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/aace99ed-5d25-4cf6-98a2-631459ae5fa2";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/aace99ed-5d25-4cf6-98a2-631459ae5fa2";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6125-B937";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/mnt/drives/xhdd2000" =
    { device = "/dev/disk/by-uuid/e2873f44-a0b2-4c05-9e8a-d14e9cade796";
      fsType = "btrfs";
      options = [ "nofail" "compress=zstd" "noatime" "space_cache=v2" ];
    };

  fileSystems."/mnt/drives/hdd1000.1" =
    { device = "/dev/disk/by-uuid/27b9a1ab-0bb3-4e2f-bc9b-7c4a227dbb2f";
      fsType = "btrfs";
      options = [ "nofail" "compress=zstd" "noatime" "space_cache=v2" ];
    };

  fileSystems."/mnt/drives/hdd500" =
    { device = "/dev/disk/by-uuid/AC50BCE250BCB504";
      fsType = "ntfs";
      options = [ "nofail" "uid=1000" "gid=100" "rw" "user" "exec" "umask=000" ];
    };

  fileSystems."/mnt/drives/hdd250.1" =
    { device = "/dev/disk/by-uuid/e7b47531-8e65-4096-be54-ca0648b0fe62";
      fsType = "btrfs";
      options = [ "nofail" "compress=zstd" "noatime" "space_cache=v2" ];
    };

  fileSystems."/mnt/old/cachyos-home" =
    { device = "/dev/disk/by-uuid/4e88875a-7b40-4ed2-8bd8-d42867685e36";
      fsType = "btrfs";
      options = [ "nofail" "subvol=@home" "compress=zstd" "noatime" "discard=async" "space_cache=v2" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
