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
                    replicas = 1;
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
                            containers.jellyfin = {
                                image = cfg.kubernetes.image;
                                ports = [ { containerPort = 8096; protocol = "TCP"; } ];
                                volumeMounts = {
                                    "/config".name = configVolumeName;
                                    "/media".name = mediaVolumeName;
                                };
                            };

                            volumes.${configVolumeName}.persistentVolumeClaim.claimName = configClaimName;
                            volumes.${mediaVolumeName}.persistentVolumeClaim.claimName = cfg.kubernetes.volumes.media.name;
                        };
                    };
                };
            };

            persistentVolumeClaims.${configClaimName} = {
                metadata = {
                    namespace = cfg.kubernetes.namespace;
                };
                spec = {
                    resources.requests.storage = "20Gi";
                    accessModes = [ "ReadWriteOncePod" ];
                    storageClassName = "longhorn"; # TODO ?
                };
            };

            services.${serviceName} = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    selector.app = appName;
                    ports = [
                        {
                            port = 8096;
                            targetPort = 8096;
                            protocol = "TCP";
                        }
                    ];
                };
            };

            # TODO: make constants for domain names and such
            ingresses = {
                jellyfin = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                            "traefik.ingress.kubernetes.io/router.tls" = "true"; # string, not boolean type.
                        };
                    };
                    spec = {
                        rules = [
                            {
                                host = "jellyfin.awesomecooldomain.pp.ua";
                                http.paths = [
                                    {
                                        path = "/";
                                        pathType = "Prefix";
                                        backend = {
                                            service = {
                                                name = serviceName;
                                                port.number = 8096;
                                            };
                                        };
                                    }
                                ];
                            }
                        ];
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
                        rules = [
                            {
                                host = "jellyfin.local";
                                http.paths = [
                                    {
                                        path = "/";
                                        pathType = "Prefix";
                                        backend = {
                                            service = {
                                                name = serviceName;
                                                port.number = 8096;
                                            };
                                        };
                                    }
                                ];
                            }
                            {
                                host = "jellyfin.homelab";
                                http.paths = [
                                    {
                                        path = "/";
                                        pathType = "Prefix";
                                        backend = {
                                            service = {
                                                name = serviceName;
                                                port.number = 8096;
                                            };
                                        };
                                    }
                                ];
                            }
                        ];
                    };
                };
            };
        };
    };
}
