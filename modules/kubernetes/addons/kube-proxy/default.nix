{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.kube-proxy;
in {
    imports = [ 
        kubenix.modules.k8s
        kubenix.modules.helm
    ];

    options.addons.kube-proxy = {
        enable = lib.mkEnableOption "kube-proxy";
        
        masterAddress = lib.mkOption {
            type = lib.types.str;
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes = {
            helm.releases.kube-proxy = {
                chart = kubenix.lib.helm.fetch {
                    repo = "https://stevehipwell.github.io/helm-charts/";
                    chart = "kube-proxy";
                    version = "0.0.8";
                    sha256 = "QSx97RgygZpyWq6W+++CtRQyKLe0hQe26VkHdvsMIqU=";
                };

                namespace = "kube-system";

                values = {
                    image.tag = "1.35.1";
                    apiServer.endpoint = cfg.masterAddress;
                };
            };
        };
    };
}