# TODO: configure jellyfin entirely though nix, and not through the UI.

# TODO: find out how to use a gpu oppertunistically and not forceibly 
# this seems to not be possible due to the fundamental design of kubernetes
# alternatives could be hashicorp nomad/consul

{ lib, kubenix, config, options, ... }:
let
    cfg = config.services.jellyfin;
in {
    imports = [ kubenix.modules.k8s ];

    options.services.jellyfin = {
        enable = lib.mkEnableOption "Jellyfin media server";

        kubernetes = {
            volumes = {
                media.name = lib.mkOption {
                    type = lib.types.str;
                    description = "The name used for the media Persistent Volume Claim";
                };
            };

            namespace = lib.mkOption {
                type = lib.types.str;
                description = "The Kubernetes namespace for all related resources";
                default = "media";
            };

            # TODO: find a way to pin this per configuration version or whatever
            image = lib.mkOption {
                type = lib.types.str;
                description = "use linuxserver/jellyfin and set a version";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes.resources = let
            appName = "jellyfin";

            serviceName = "jellyfin";

            configClaimName = "jellyfin-config";
            configTemplatesConfigMapName = "jellyfin-config-template";
            scriptsConfigMapName = "jellyfin-scripts";
        in {
            deployments.jellyfin = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    repliacs = 1;
                    strategy.type = "Recreate";
                    selector.matchLabels.app = appName;
                    template = {
                        metadata.labels.app = appName;
                        spec = let
                          configVolumeName = "config";
                          mediaVolumeName = "media";
                          configTemplatesVolumeName = "config-templates";
                          scriptsVolumeName = "scripts";
                        in {
                            # TODO: find a way to use nix enums or something to make this more type safe
                            affinity.nodeAffinity.preferredDuringSchedulingIgnoredDuringExecution = [
                                {
                                    weight = 10;
                                    preference.matchExpressions = [
                                        {
                                            key = "gpu.type";
                                            operator = "In";
                                            vaules = [ "nvidia" "amd" "intel" ];
                                        }
                                    ];
                                }
                                {
                                    weight = 100;
                                    preference.matchExpressions = [
                                        {
                                            key = "gpu.class";
                                            operator = "In";
                                            values = [ "high" ];
                                        }
                                    ];
                                }
                                {
                                    weight = 50;
                                    preference.matchExpressions = [
                                        {
                                            key = "gpu.class";
                                            operator = "In";
                                            values = [ "mid" ];
                                        }
                                    ];
                                }
                                {
                                    weight = 10;
                                    preference.matchExpressions = [
                                        {
                                            key = "gpu.class";
                                            operator = "In";
                                            values = [ "low" ];
                                        }
                                    ];
                                }
                            ];

                            containers.jellyfin = {
                                image = cfg.kubernetes.image;
                                ports = [ { containerPort = 8096; } ];
                                volumeMounts = {
                                    "/config".name = configVolumeName;
                                    "/media".name = mediaVolumeName;
                                    # "/templates".name = configTemplatesVolumeName;
                                    # "scripts".name = scriptsVolumeName;
                                };
                            };

                            # initContainers.configure-encoding = {
                            #     image = "busybox";
                            #     command = [
                            #       "sh"
                            #       "/scripts/configure-encoding.sh"
                            #     ];
                            # };

                            volumes.${configVolumeName}.persistentVolumeClaim.name = configClaimName;
                            volumes.${mediaVolumeName}.persistentVolumeClaim.name = cfg.kubernetes.volumes.media.name;
                        };
                    };
                };
            };

            persistentVolumeClaims.${configClaimName} = {
                metadata = {
                    namespace = cfg.kubernetes.namespace;
                    spec = {
                        accessModes = [ "ReadWriteOncePod" ];
                        storageClassName = "longhorn"; # TODO ?
                    };
                };
            };

            # configMaps.${configTemplatesConfigMapName} = {
            #     metadata.namespace = cfg.kubernetes.namespace;
            #     data."encoding.xml.tpl" = builtins.readFile ./config/encoding.xml.tpl;
            # };

            # configMaps.${scriptsConfigMapName} = {
            #     metadata.namespace = cfg.kubernetes.namespace;
            #     data."configure-encoding.sh" = builtins.readFile ./scripts/configure-encoding.sh;
            # };

            services.${serviceName} = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    selector.app = appName;
                    ports = [
                        {
                            port = 8096;
                            targetPort = 8096;
                        }
                    ];
                };
            };

            # TODO: make constants for domain names and such
            ingress = {
                jellyfin = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                            "traefik.ingress.kubernetes.io/router.tls" = "true"; # string, not boolean type.
                        };
                    };
                    spec = {
                        rules."jellyfin.awesomecooldomain.pp.ua".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = 8096;
                        };
                    };
                };

                jellyfin-local = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                        };
                    };
                    spec = {
                        rules."jellyfin.local".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = 8096;
                        };
                        rules."jellyfin.homelab".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = 8096;
                        };
                    };
                };
            };
        };
    };
}
