{ lib, kubenix, config, options, ... }:
let
    cfg = config.services.jellyseerr;
in {
    imports = [ kubenix.modules.k8s ];

    options.services.jellyseerr = {
        enable = lib.mkEnableOption "Jellyseerr Media Request Manager";

        kubernetes = {
            namespace = lib.mkOption {
                type = lib.types.str;
                description = "The Kubernetes namespace for all related resources";
                default = "media";
            };

            # TODO: find a way to pin this per configuration version or whatever
            image = lib.mkOption {
                type = lib.types.str;
                description = "use linuxserver/jellyseerr and set a version";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes.resources = let
            appName = "jellyseerr";

            serviceName = "jellyseerr";

            configClaimName = "jellyseerr-config";

            httpPort = 5055;
        in {
            deployments.jellyseerr = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    repliacs = 1;
                    strategy.type = "Recreate";
                    selector.matchLabels.app = appName;
                    template = {
                        metadata.labels.app = appName;
                        spec = let
                          configVolumeName = "config";
                        in {
                            containers.jellyseerr = {
                                image = cfg.kubernetes.image;
                                ports = [ 
                                    { 
                                        containerPort = httpPort;
                                    }
                                ];
                                volumeMounts = {
                                    "/app/config".name = configVolumeName;
                                };
                            };

                            volumes = {
                                configVolumeName.persistentVolumeClaim.name = configClaimName;
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
                    ];
                };
            };

            # TODO: make constants for domain names and such
            ingress = {
                jellyseerr = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                            "traefik.ingress.kubernetes.io/router.tls" = "true"; # string, not boolean type.
                        };
                    };
                    spec = {
                        rules."jellyseerr.awesomecooldomain.pp.ua".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };

                jellyseerr-local = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                        };
                    };
                    spec = {
                        rules."jellyseerr.local".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                        rules."jellyseerr.homelab".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };
            };
        };
    };
}