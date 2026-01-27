{ config, hostname, inputs, lib, role, template,  ... }: {
    services.keepalived.vrrpInstances.kube_api = {
        state = "MASTER";
        priority = 100;
    };
}