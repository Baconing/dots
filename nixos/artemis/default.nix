{config, inputs, lib, pkgs, username, ...}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
  ];

  boot = {
    resumeDevice = "/dev/mapper/cryptswap";
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-id/nvme-SERIAL_NUMBER-part3";
        preLVM = true;
      };
      crypthome.device = "/dev/disk/by-id/nvme-SERIAL_NUMBER-part4";
      cryptswap = {
        device = "/dev/disk/by-id/nvme-SERIAL_NUMBER-part2";
        preLVM = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-id/nvme-SERIAL_NUMBER-part1";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/home" = {
      device = "/dev/mapper/crypthome";
      fsType = "btrfs";
    };
  };

  swapDevices = [{ device = "/dev/mapper/cryptswap"; }];

}
