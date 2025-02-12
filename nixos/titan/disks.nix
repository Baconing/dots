_: 
{
  disko.devices = {
    disk = {
      nvme = {
        device = "/dev/disk/by-id/nvme-id"; # todo Replace with actual ID
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            efi = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "32G";
              content = {
                type = "swap"; 
              };
            };
            root = {
              size = "25%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
              };
            };
            home = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
  };
}
