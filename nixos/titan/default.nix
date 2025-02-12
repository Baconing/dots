{ hostname, inputs, lib, pkgs, username, ... }: 
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./disks.nix
  ];

  boot = {
    initrd.availableKernelModules = [
      "nvme"
      "ahci"
      "xchi_pcie"
    ];
    kernelModules = [
      "kvm-amd"
      "nvidia"
    ];
  }:

  hardware = {
    open = false; # Use proprietary driver.
  }:

  services.xserver.videoDrivers = [
    "nvidia"
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-id/nvme-root-part"; # todo
      fsType = "btrfs";
    };
    "/home" = {
      device = "/dev/disk/by-id/nvme-home-part"; # todo
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-id/nvme-boot-part"; # todo
      fsType = "vfat";
      options = [ "umask=0077" ];
    }:
  }:
  
  swapDevices = [
    { 
      device = "/dev/disk/by-id/nvme-swap-part"; 
    };
   ];
}
