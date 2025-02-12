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
              size = "16G";
              content = {
                type = "luks";
                name = "cryptswap";
                passwordFile = "/run/secrets/luks_encryption_password"
                content = { 
                  type = "swap"; 
                };
              };
            };
            root = {
              size = "25%";
              content = {
                type = "luks";
                name = "cryptroot";
                passwordFile = "/run/secrets/luks_encryption_password"
                content = {
                  type = "filesystem";
                  format = "btrfs";
                  mountpoint = "/";
                };
              };
            };
            home = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypthome";
                passwordFile = "/run/secrets/luks_encryption_password"
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
  };
}
