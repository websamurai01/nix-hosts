{ ... }:

{
  disko.devices.disk = {
    root = {
      # crypto_LUKS container behind /dev/mapper/cryptroot
      device = "/dev/disk/by-uuid/bb963487-5086-44a3-bbc1-4accaa93c0b6";
      type = "disk";
      destroy = false;
      content = {
        type = "luks";
        name = "cryptroot";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "@" = {
              mountpoint = "/";
            };
            "@home" = {
              mountpoint = "/home";
            };
          };
        };
      };
    };

    boot = {
      device = "/dev/disk/by-uuid/12CE-A600";
      type = "disk";
      destroy = false;
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
    };

    games = {
      device = "/dev/disk/by-uuid/f8c3594c-50f0-40ef-8a02-33fa6866c696";
      type = "disk";
      destroy = false;
      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        mountpoint = "/mnt/drives/games";
        mountOptions = [
          "nofail"
          "compress=zstd"
          "noatime"
          "space_cache=v2"
        ];
      };
    };
  };
}
