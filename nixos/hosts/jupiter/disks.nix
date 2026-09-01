_:
{
    boot.loader.efi.efiSysMountPoint = "/boot";

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/root";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/boot";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
    };
  
    swapDevices = [
        { 
            device = "/swapfile"; 
        }
    ];
}