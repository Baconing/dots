{ config, hostname, inputs, lib, clusterRole, template,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-intel
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    services.keepalived.vrrpInstances.kube_api.interface = "eno1";
}