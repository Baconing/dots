{ config, hostname, inputs, lib, clusterRole, clusterTemplate,  ... }: 
{
    imports = [
        inputs.sops-nix.nixosModules.sops
        inputs.nixos-hardware.nixosModules.common-pc
        ../../modules/nixos
    ] ++ lib.optional (clusterTemplate != "") ./template/${clusterTemplate} ++ lib.optional (builtins.pathExists ./node/${hostname}) ./node/${hostname};
  
    boot.loader.efi.efiSysMountPoint = "/boot";

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
    };
  
    swapDevices = [
        { 
            device = "/swapfile"; 
        }
    ];

    sops.secrets.kubernetes-token = {
        sopsFile = ./kubernetes.secret.yaml;
        #owner = config.systemd.services.k3s.serviceConfig.user; #todo
        restartUnits = [ "k3s.service" ];
    };

    homelab = {
        services = {
            kubernetes = {
                enable = true;
                role = clusterRole;
                tokenFile = config.sops.secrets.kubernetes-token.path;
                masterAddress = "https://10.10.254.253:6443"; # todo
                vip = "10.10.254.253";
            };
        };
    };
}