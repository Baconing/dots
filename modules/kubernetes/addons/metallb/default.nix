{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.metallb;
in {
    imports = [
        kubenix.modules.k8s
        kubenix.modules.helm
    ];

    options.addons.metallb = {
        enable = lib.mkEnableOption "MetalLB load balancer (helm)";
    };

    config = lib.mkIf cfg.enable {
        kubernetes.helm.releases.metallb = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://metallb.github.io/metallb";
                chart = "metallb";
                version = "0.15.3";
                sha256 = "KWdVaF6CjFjeHQ6HT1WvkI9JnSurt9emLVCpkxma0fg=";
            };
        };

        kubernetes.customTypes = {
            ipAddressPool = {
                attrName = "ipAddressPool";
                group = "metallb.io";
                kind = "IPAddressPool";
                version = "v1beta1";
            };
            l2Advertisement = {
                attrName = "l2Advertisement";
                group = "metallb.io";
                kind = "L2Advertisement";
                version = "v1beta1";
            };
        };
    };
}