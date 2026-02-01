{ config, hostname, inputs, lib, clusterRole, template,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    services.keepalived.vrrpInstances.kube_api = {
        interface = "enp42s0";
        state = "MASTER";
        priority = 100;
    };
}