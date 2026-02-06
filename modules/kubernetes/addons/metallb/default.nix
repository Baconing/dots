{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.metallb;
in {
    imports = [ kubenix.modules.k8s ];

    options.addons.metallb = {
        enable = lib.mkEnableOption "MetalLB load balancer (helm)";
    };

    config = lib.mkIf cfg.enable {
        kubernetes.helm.releases.metallb = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://metallb.github.io/metallb";
                chart = "metallb";
                version = "0.15.3";
                sha256 = "27db761c5ad2525fd130c92fe2f2d4500f8870e402fefe3c9cb8d34d8a71a70c";
            };
        };
    };
}