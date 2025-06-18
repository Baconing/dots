{ config, hostname, inputs, lib, pkgs, username, ... }: 
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [ apfs ];
  
  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "ahci"
      #"xchi_pcie"
    ];
    kernelModules = [
      "kvm-amd"
      "nvidia"
    ];
  };


  hardware = {
    nvidia = {
      modesetting.enable = true;
      open = true;

      prime = {
        sync.enable = false;
        offload.enable = false;
        reverseSync.enable = false;
      };
    };
  };

  services.xserver.videoDrivers = [
    "nvidia"
  ];
  
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-label/ROOT";
 
  sops.secrets = {
    cryptSwapKey = {
      sopsFile = ../../secrets/hosts/titan/swap.key;
      format = "binary";
    };
    cryptHomeKey = {
      sopsFile = ../../secrets/hosts/titan/home.key;
      format = "binary";
    };
    
    cifsPhoebeUsername = {
      sopsFile = ../../secrets/hosts/titan/cifs.yaml;
      key = "username";
      format = "yaml";
    };
    cifsPhoebePassword = {
      sopsFile = ../../secrets/hosts/titan/cifs.yaml;
      key = "password";
      format = "yaml";
    };
  };
  sops.templates = {
    "cifsPhoebeCredentials".content = ''
      username=${config.sops.placeholder.cifsPhoebeUsername}
      password=${config.sops.placeholder.cifsPhoebePassword}
    '';
  };

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      cryptswap LABEL=SWAP ${config.sops.secrets.cryptSwapKey.path}
      crypthome LABEL=HOME ${config.sops.secrets.cryptHomeKey.path}
    '';
  };

  fileSystems = {
    "/" = {
      device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
    };
    "/home" = {
      device = "/dev/mapper/crypthome";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-label/EFI";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    "/mnt/phoebe/vault" = {
      device = "//phoebe-truenas.local/vault";
      fsType = "cifs";
      options = [
      	"x-systemd.automount"
	"noauto"
	"x-systemd.idle-timeout=60"
	"x-systemd.device-timeout=5s"
	"x-systemd.mount-timeout=5s"
	"credentials=${config.sops.templates."cifsPhoebeCredentials".path}"
	"uid=1000" # todo: fix this
	"gid=100" # todo: ^
      ];
    };
    "/mnt/phoebe/media" = {
      device = "//phoebe-truenas.local/media";
      fsType = "cifs";
      options = [
      	"x-systemd.automount"
	"noauto"
	"x-systemd.idle-timeout=60"
	"x-systemd.device-timeout=5s"
	"x-systemd.mount-timeout=5s"
	"credentials=${config.sops.templates."cifsPhoebeCredentials".path}"
	"uid=1000" # todo: fix this
	"gid=100" # todo: ^
      ];
    };
    "/mnt/phoebe/torrent" = {
      device = "//phoebe-truenas.local/torrent";
      fsType = "cifs";
      options = [
      	"x-systemd.automount"
	"noauto"
	"x-systemd.idle-timeout=60"
	"x-systemd.device-timeout=5s"
	"x-systemd.mount-timeout=5s"
	"credentials=${config.sops.templates."cifsPhoebeCredentials".path}"
	"uid=1000" # todo: fix this
	"gid=100" # todo: ^
      ];
    };
  };
  
  swapDevices = [
    { 
      device = "/dev/mapper/cryptswap"; 
    }
  ];
}
