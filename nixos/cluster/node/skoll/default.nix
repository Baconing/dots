{ config, hostname, inputs, lib, clusterRole, template,  ... }: {
    services.keepalived.vrrpInstances.kube_api = {
        state = "MASTER";
        priority = 100;
    };
}