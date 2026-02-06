{ lib, kubenix, config, ... }:
let
    cfg = config.services.lidarr;
{
    imports = [ kubenix.modules.k8s ];

    options.services.lidarr = {
        enable = lib.mkEnableOption "Lidarr music library manager";

        kubernetes = {
            volumes = {
                media.name = lib.mkOption {
                    type = lib.types.str;
                    description = "The name used for the media Persistent Volume";
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
                description = "use linuxserver/lidarr and set a version, or ghcr.io/hotio/lidarr:pr-plugins (for plugins support)";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes.resources = let
            appName = "lidarr";

            serviceName = "lidarr";

            configClaimName = "lidarr-config";

            httpPort = 8686;
        in {
            deployments.lidarr = {
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
                        in {
                            containers.lidarr = {
                                image = cfg.kubernetes.image;
                                ports = [ 
                                    { 
                                        containerPort = httpPort;
                                    }
                                ];
                                volumeMounts = {
                                    "/config".name = configVolumeName;
                                    "/media".name = mediaVolumeName;
                                };
                            };

                            volumes = {
                                configVolumeName.persistentVolumeClaim.name = configClaimName;
                                mediaVolumeName.persistentVolumeClaim.name = cfg.kubernetes.volumes.media.name;
                            };
                        };
                    };
                };
            };

            persistentVolumeClaims.${configClaimName} = {
                metadata = {
                    namespace = cfg.kubernetes.namespace;
                    spec = {
                        accessModes = [ "ReadWriteMany" ];
                        storageClassName = "longhorn"; # TODO ?
                    };
                };
            };

            services.${serviceName} = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    selector.app = appName;
                    ports = [
                        {
                            port = httpPort;
                            targetPort = httpPort;
                        }
                    ]
                };
            };

            # TODO: make constants for domain names and such
            ingress = {
                lidarr = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                            "traefik.ingress.kubernetes.io/router.tls" = "true"; # string, not boolean type.
                        };
                    };
                    spec = {
                        rules."lidarr.awesomecooldomain.pp.ua".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };

                lidarr-local = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                        };
                    };
                    spec = {
                        rules."lidarr.local".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                        rules."lidarr.homelab".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };
            };
        };
    };
}