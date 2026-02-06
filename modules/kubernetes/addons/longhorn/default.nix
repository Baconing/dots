{ lib, kubenix, ... }:
let
    cfg = config.addons.longhorn;
in {
    imports = [ 
        ../kyverno
        kubenix.modules.k8s
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
                sha256 = "a871d397e19cf3243949abd41fd294869f5c2c490014f29e71866a2433ec7fb9";
            };
        };

        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/networking/cluster/k3s/docs/examples/STORAGE.md
        kubernetes.resources = let 
            configMapName = "longhorn-nixos-path";
        in {
            configMaps.${configMapName} = {
                namespace = "longhorn-system";
                data."PATH" = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/run/wrappers/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
            };

            "longhorn-add-nixos-path" = {
                apiVersion = "kyverno.io/v1";
                kind = "ClusterPolicy";
                metadata = {
                    annotations = {
                        "policies.kyverno.io/title" = "Add Environment Variables from ConfigMap";
                        "policies.kyverno.io/subject" = "Pod";
                        "policies.kyverno.io/category" = "Other";
                        "policies.kyverno.io/description" = ''
                            Longhorn invokes executables on the host system, and needs
                            to be aware of the host systems PATH. This modifies all
                            deployments such that the PATH is explicitly set to support
                            NixOS based systems.
                        '';
                    };
                };

                spec = {
                    rules = [
                        {
                            name = "add-env-vars";
                            match.resources = {
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
                };
            };
        };
    };
}