{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.longhorn;
in {
    imports = [
        kubenix.modules.k8s
        kubenix.modules.helm
    ];

    options.addons.longhorn = {
        enable = lib.mkEnableOption "Longhorn Distributed Block Storage";
    };

    config = lib.mkIf cfg.enable {
        addons.kyverno.enable = true;

        kubernetes.helm.releases.longhorn = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://charts.longhorn.io";
                chart = "longhorn";
                version = "1.10.1";
                sha256 = "nkS4nvFK+K7J/sE+OxOPY0nR3lkrQF5K7JM5zbXLJ0s=";
            };

            namespace = "longhorn-system";
        };

        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/examples/STORAGE.md
        kubernetes.resources = let 
            configMapName = "longhorn-nixos-path";
        in {
            configMaps.${configMapName} = {
                metadata.namespace = "longhorn-system";
                data."PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
            };

            clusterPolicies."longhorn-add-nixos-path" = {
                metadata = {
                    annotations = {
                        "policies.kyverno.io/subject" = "Pod";
                        "policies.kyverno.io/category" = "Other";
                    };
                };

                spec = {
                    rules = [
                        {
                            name = "add-env-vars";
                            match.any = [ 
                                {
                                    resources = {
                                        kinds = [ "Pod" ];
                                        namespaces = [ "longhorn-system" ];
                                    };
                                }
                            ];
                            mutate.patchStrategicMerge = {
                                spec = {
                                    initContainers = [
                                        {
                                            "(name)" = "*";
                                            envFrom = [
                                                {
                                                    configMapRef.name = configMapName;
                                                }
                                            ];
                                        }
                                    ];
                                    containers = [
                                        {
                                            "(name)" = "*";
                                            envFrom = [
                                                {
                                                    configMapRef.name = configMapName;
                                                }
                                            ];
                                        }
                                    ];
                                };
                            };
                        }
                    ];
                };
            };
        };
    };
}