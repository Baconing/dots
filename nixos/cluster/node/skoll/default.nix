{ config, hostname, inputs, lib, clusterRole, template, pkgs,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    hardware.enableRedistributableFirmware = true;

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            intel-compute-runtime
            libvdpau-va-gl
            vpl-gpu-rt
        ];
    };

    environment.systemPackages = with pkgs; [
        intel-gpu-tools
        libva-utils
    ];

    homelab.services.kubernetes.netDev = "enp42s0";
}