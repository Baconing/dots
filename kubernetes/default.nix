{ options, kubenix, ... }:
{
    imports = [
        ./media
        ../../modules/kubernetes
        kubenix.modules.k8s
    ];

    helm.metallb.enable = true;

    kubernetes = let
        homelabIPPoolName = "homelab-metallb-pool";
    in {
        resources.${homelabIPPoolName} =  {
            apiVersion = "metallb.io/v1beta1";
            kind = "IPAddressPool";
            metadata.namespace = "metallb-system";
            spec.addresses = "10.10.254.254-10.10.254.254";
        };
        resources."homelab-l2-advertisement" = {
            apiVersion = "metallb.io/v1beta1";
            kind = "L2Advertisement";
            metadata.namespace = "metallb-system";
            spec.ipAddressPools = homelabIPPoolName;
        };
    };
}