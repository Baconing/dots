{ config, hostname, inputs, lib, clusterRole, template, pkgs,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            libvdpau-va-gl
            vpl-gpu-rt
        ];
    };

    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

    homelab.services.kubernetes.netDev = "enp42s0";
}