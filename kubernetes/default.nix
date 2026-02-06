{ options, kubenix, ... }:
{
    imports = [
        ./media
        ../modules/kubernetes
        kubenix.modules.k8s
    ];

    addons.metallb.enable = true;

    kubernetes = let
        homelabIPPoolName = "homelab-metallb-pool";
    in {
        resources = {
            ipAddressPool.${homelabIPPoolName} =  {
                apiVersion = "metallb.io/v1beta1";
                kind = "IPAddressPool";
                spec.addresses = [ "10.10.254.254" ];
            };

            l2Advertisement."homelab-l2-advertisement" = {
                apiVersion = "metallb.io/v1beta1";
                kind = "L2Advertisement";
                spec.ipAddressPools = [ homelabIPPoolName ];
            };
        };
    };
}