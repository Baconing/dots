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

    #todo
    #addons.flannel = {
    #    enable = true;
    #    cidr = "10.42.0.0/16";
    #};

    addons.kube-proxy = {
        enable = true;
        masterAddress = "https://10.10.254.253:6443";
    };

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