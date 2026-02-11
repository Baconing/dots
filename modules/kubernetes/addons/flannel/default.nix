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
            };
        };
    };
}