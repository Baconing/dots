{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.kyverno;
in {
    imports = [ 
        kubenix.modules.k8s
        kubenix.modules.helm
    ];

    options.addons.kyverno = {
        enable = lib.mkEnableOption "Kyverno Policy as Code Manager";
    };

    config = lib.mkIf cfg.enable {
        kubernetes = {
            helm.releases.kyverno = {
                chart = kubenix.lib.helm.fetch {
                    repo = "https://kyverno.github.io/kyverno/";
                    chart = "kyverno";
                    version = "3.7.0-rc.1";
                    sha256 = "rH3qZRecYtPxlQQz/lumfOT+YHIU8ouEQqBQE3pEPlU=";
                };

                namespace = "kyverno";
            };

            resources.namespaces = {
                "kyverno" = {
                    metadata = {
                        name = "kyverno";
                    };
                };
            };

            customTypes = {
                clusterPolicies = {
                    attrName = "clusterPolicies";
                    group = "kyverno.io";
                    kind = "ClusterPolicy";
                    version = "v1";
                };
            };
        };
    };
}