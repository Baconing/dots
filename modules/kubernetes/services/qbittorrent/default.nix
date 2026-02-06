{ lib, kubenix, config, ... }:
let
    cfg = config.services.qbittorrent;
{
    imports = [ kubenix.modules.k8s ];

    options.services.qbittorrent = {
        enable = lib.mkEnableOption "qBitTorrent Client";
        torrentingPort = lib.mkOption {
            type = lib.types.port;
        };

        kubernetes = {
            volumes = {
                downloads.name = lib.mkOption {
                    type = lib.types.str;
                    description = "The name used for the downloads Persistent Volume";
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
                description = "use linuxserver/qbittorrent and set a version";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes.resources = let
            appName = "qbittorrent";

            serviceName = "qittorrent";

            configClaimName = "qbittorrent-config";

            httpPort = 8080;
        in {
            deployments.qbittorrent = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    repliacs = 1;
                    strategy.type = "Recreate";
                    selector.matchLabels.app = appName;
                    template = {
                        metadata.labels.app = appName;
                        spec = let
                          configVolumeName = "config";
                          downloadsVolumeName = "downloads";
                        in {
                            containers.qbittorrent = {
                                image = cfg.kubernetes.image;
                                ports = [ 
                                    { 
                                        containerPort = httpPort;
                                    }

                                    { 
                                        containerPort = cfg.torrentingPort;
                                    }

                                    { 
                                        containerPort = cfg.torrentingPort;
                                        protocol = "UDP";
                                    }
                                ];
                                environment = {
                                    WEBUI_PORT = httpPort;
                                    TORRENTING_PORT = cfg.torrentingPort;
                                };
                                volumeMounts = {
                                    "/config".name = configVolumeName;
                                    "/downloads".name = downloadsVolumeName;
                                };
                            };

                            volumes = {
                                configVolumeName.persistentVolumeClaim.name = configClaimName;
                                downloadsVolumeName.persistentVolumeClaim.name = cfg.kubernetes.volumes.downloads.name;
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
                        {
                            port = cfg.torrentingPort;
                            targetPort = cfg.torrentingPort;
                        }
                        {
                            port = cfg.torrentingPort;
                            targetPort = cfg.torrentingPort;
                            protocol = "UDP";
                        }
                    ]
                };
            };

            # TODO: make constants for domain names and such
            ingress = {
                qbittorrent = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                            "traefik.ingress.kubernetes.io/router.tls" = "true"; # string, not boolean type.
                        };
                    };
                    spec = {
                        rules."torrent.awesomecooldomain.pp.ua".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };

                qbittorrent-local = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                        };
                    };
                    spec = {
                        rules."torrent.local".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                        rules."torrent.homelab".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };
            };
        };
    };
}