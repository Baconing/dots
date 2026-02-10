{ config, hostname, inputs, lib, clusterRole, template,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    homelab.services.kubernetes.masterAddress = lib.mkForce null;
    homelab.services.kubernetes.clusterInit = true;

    services.keepalived.vrrpInstances.kube_api = {
        interface = "enp42s0";
        state = lib.mkForce "MASTER";
        priority = lib.mkForce 100;
    };
}