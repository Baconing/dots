{ lib, kubenix, ... }:
let
    cfg = config.modules.kyverno;
in {
    imports = [ kubenix.modules.k8s ];

    options.modules.kyverno = {
        enable = lib.mkEnableOption "Kyverno Policy as Code Manager";
    };

    config = lib.mkIf cfg.enable {
        kubernetes.helm.releases.kyverno = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://kyverno.github.io/kyverno/";
                chart = "kyverno";
                version = "3.7.0-rc.1";
                sha256 = "37738661a2c69fd575a43d57a0833f56d9c59acdb7123911682ec3937d3de90d";
            };
        };
    };
}