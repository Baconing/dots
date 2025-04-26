{config, inputs, lib, pkgs, username, ...}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
    inputs.sops-nix.nixosModules.sops
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ apfs ];

  fileSystems = {
    "/" = {
      device = "/dev/nvme0n1p4"; # todo
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };
    "/home" = {
      device = "/dev/nvme0n1p3"; # todo
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/nvme0n1p5"; # todo
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/mnt/macos" = {
      device = "/dev/nvme0n1p2";
      fsType = "apfs";
    };
    "/mnt/phoebe/vault" = {
      device = "//10.10.5.20/vault";
      fsType = "cifs";
      options = let
	credentialsFile = config.sops.secrets.phoebeCredentials.path;
	uid = toString config.users.users.${username}.uid;
      in [ "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5,credentials=${credentialsFile},uid=${uid}" ];
    };
    "/mnt/phoebe/media" = {
      device = "//10.10.5.20/media";
      fsType = "cifs";
      options = let
	credentialsFile = config.sops.secrets.phoebeCredentials.path;
	uid = toString config.users.users.${username}.uid;
      in [ "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5,credentials=${credentialsFile},uid=${uid}" ];
    };
    "/mnt/phoebe/isos" = {
      device = "//10.10.5.20/isos";
      fsType = "cifs";
      options = let
	credentialsFile = config.sops.secrets.phoebeCredentials.path;
	uid = toString config.users.users.${username}.uid;
      in [ "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5,credentials=${credentialsFile},uid=${uid}" ];
    };
  };

# once encryption is done
/*
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
*/
}
