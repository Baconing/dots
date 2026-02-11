{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.flannel;
in {
    imports = [ 
        kubenix.modules.k8s
        kubenix.modules.helm
    ];

    options.addons.flannel = {
        enable = lib.mkEnableOption "Flannel CNI";

        cidr = lib.mkOption {
            type = lib.types.str;
            description = "The CIDR for pods to use";
        };

        backend = lib.mkOption {
            type = lib.types.enum [ "vxlan" "host-gw" "wireguard" "udp" ];
            default = "vxlan";
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes = {
            helm.releases.flannel = {
                chart = kubenix.lib.helm.fetch {
                    chart = "flannel";
                    chartUrl = "https://github.com/flannel-io/flannel/releases/download/v0.28.1/flannel.tgz"; # todo: chartUrl seems to be broken as of right now
                    sha256 = "rH3qZRecYtPxlQQz/lumfOT+YHIU8ouEQqBQE3pEPlU=";
                };

                namespace = "kube-flannel";

                values = {
                    podCidr = cfg.cidr;
                    flannel = {
                        backend = cfg.backend;
                    };
                };
            };
        };
    };
}