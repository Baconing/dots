{ options, kubenix, ... }:
{
    imports = [
        ./media
        ../modules/kubernetes
        kubenix.modules.k8s
    ];

    addons.metallb.enable = true;
    addons.longhorn.enable = true;
    addons.smb.enable = true;
    
    kubernetes = let
        homelabIPPoolName = "homelab-metallb-pool";
    in {
        resources = {
            ipAddressPool.${homelabIPPoolName} =  {
                metadata.namespace = "metallb-system";
                spec.addresses = [ "10.10.254.254/32" ];
            };

            l2Advertisement."homelab-l2-advertisement" = {
                metadata.namespace = "metallb-system";
                spec.ipAddressPools = [ homelabIPPoolName ];
            };
        };
    };
}