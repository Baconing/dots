{ config, hostname, inputs, lib, clusterRole, clusterTemplate, clusterIP,  ... }: 
{
    imports = [
	./desktops
	./services
    ] ++ lib.optional (builtins.pathExists ./hosts/${hostname}) ./hosts/${hostname};
  
    boot.loader.efi.efiSysMountPoint = "/boot";

    fileSystems = {
        "/" = {
            device = "/dev/mapper/root";
            fsType = "btrfs";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
    };
  
    swapDevices = [
        { 
            device = "/swap/swapfile";
	    size = 32*1024; # 32GB
        }
    ];

    boot.initrd.luks.devices."root" = {
        device = "/dev/disk/by-label/ROOT";
    };


    networking.networkmanager.enable = true;
    users.users.bacon.extraGroups = [ "networkmanager" ];
}
