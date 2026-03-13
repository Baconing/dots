{ config, hostname, inputs, lib, clusterRole, template,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    boot.blacklistedKernelModules = [ "nouveau" ];
    hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        datacenter.enable = true;
    };
    hardware.nvidia-container-toolkit.enable = true;

    homelab.services.kubernetes.netDev = "enp42s0";
}