{ config, hostname, inputs, lib, clusterRole, template,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-amd
        inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    # services.k3s.extraFlags = ["--cluster-init"]; # Only enable when creating the cluster for the first time for etcd functionality.

    homelab.services.kubernetes.netDev = "enp42s0";
}