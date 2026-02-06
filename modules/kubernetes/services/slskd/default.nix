{ lib, kubenix, config, ... }:
let
    cfg = config.services.slskd;

    settingsFormat = pkgs.formats.yaml { };

    confWithoutNullValues = (
        lib.filterAttrsRecursive (
            key: value: (builtins.tryEval value).success && value != null
        ) cfg.settings
    );

    configurationYaml = settingsFormat.generate "slskd.yml" confWithoutNullValues;
in {
    imports = [ kubenix.modules.k8s ];

    options.services.slskd = {
        enable = lib.mkEnableOption "slskd Soulseek Client";

        settings = 
            with libs;
            with types;
        mkOption {
            description = ''
            Application configuration for slskd. See
            [documentation](https://github.com/slskd/slskd/blob/master/docs/config.md).
            '';
            default = { };
            type = submodule {
                freeformType = settingsFormat.type;
                options = {
                    remote_file_management = mkEnableOption "modification of share contents through the web ui";

                    flags = {
                        force_share_scan = mkOption {
                            type = bool;
                            description = "Force a rescan of shares on every startup.";
                        };
                        no_version_check = mkOption {
                            type = bool;
                            default = true;
                            visible = false;
                            description = "Don't perform a version check on startup.";
                        };
                    };

                    directories = {
                        incomplete = mkOption {
                            type = nullOr str;
                            description = "Directory where incomplete downloading files are stored.";
                            defaultText = "/var/lib/slskd/incomplete";
                            default = lib.mkForce "/media/downloads/slskd/incomplete";
                        };
                        downloads = mkOption {
                            type = nullOr str;
                            description = "Directory where downloaded files are stored.";
                            defaultText = "/var/lib/slskd/downloads";
                            default = lib.mkForce "/media/downloads/slskd/complete";
                        };
                    };

                    shares = {
                        directories = mkOption {
                            type = listOf str;
                            description = ''
                            Paths to shared directories. See
                            [documentation](https://github.com/slskd/slskd/blob/master/docs/config.md#directories)
                            for advanced usage.
                            '';
                            example = lib.literalExpression ''[ "/home/John/Music" "!/home/John/Music/Recordings" "[Music Drive]/mnt" ]'';
                            default = lib.mkForce [ "/media/music" ];
                        };
                        filters = mkOption {
                            type = listOf str;
                            example = lib.literalExpression ''[ "\.ini$" "Thumbs.db$" "\.DS_Store$" ]'';
                            description = "Regular expressions of files to exclude from sharing.";
                        };
                    };

                    rooms = mkOption {
                        type = listOf str;
                        description = "Chat rooms to join on startup.";
                    };

                    soulseek = {
                        description = mkOption {
                            type = str;
                            description = "The user description for the Soulseek network.";
                            defaultText = "A slskd user. https://github.com/slskd/slskd";
                        };
                        listen_port = mkOption {
                            type = port;
                            description = "The port on which to listen for incoming connections.";
                            default = 50300;
                        };
                    };

                    global = {
                        # TODO speed units
                        upload = {
                            slots = mkOption {
                            type = ints.unsigned;
                            description = "Limit of the number of concurrent upload slots.";
                            };
                            speed_limit = mkOption {
                            type = ints.unsigned;
                            description = "Total upload speed limit.";
                            };
                        };
                        download = {
                            slots = mkOption {
                            type = ints.unsigned;
                            description = "Limit of the number of concurrent download slots.";
                            };
                            speed_limit = mkOption {
                            type = ints.unsigned;
                            description = "Total upload download limit";
                            };
                        };
                    };

                    filters.search.request = mkOption {
                        type = listOf str;
                        example = lib.literalExpression ''[ "^.{1,2}$" ]'';
                        description = "Incoming search requests which match this filter are ignored.";
                    };

                    web = {
                        port = mkOption {
                            type = port;
                            default = lib.mkForce 5030;
                            description = "The HTTP listen port.";
                        };
                        url_base = mkOption {
                            type = path;
                            default = "/";
                            description = "The base path in the url for web requests.";
                        };
                        # Users should use a reverse proxy instead for https
                        https.disabled = mkOption {
                            type = bool;
                            default = true;
                            description = "Disable the built-in HTTPS server";
                        };
                    };

                    retention = {
                        transfers = {
                            upload = {
                                    succeeded = mkOption {
                                        type = ints.unsigned;
                                        description = "Lifespan of succeeded upload tasks.";
                                        defaultText = "(indefinite)";
                                    };
                                    errored = mkOption {
                                        type = ints.unsigned;
                                        description = "Lifespan of errored upload tasks.";
                                        defaultText = "(indefinite)";
                                    };
                                    cancelled = mkOption {
                                        type = ints.unsigned;
                                        description = "Lifespan of cancelled upload tasks.";
                                        defaultText = "(indefinite)";
                                    };
                                };
                            download = {
                                    succeeded = mkOption {
                                        type = ints.unsigned;
                                        description = "Lifespan of succeeded download tasks.";
                                        defaultText = "(indefinite)";
                                    };
                                    errored = mkOption {
                                        type = ints.unsigned;
                                        description = "Lifespan of errored download tasks.";
                                        defaultText = "(indefinite)";
                                    };
                                    cancelled = mkOption {
                                        type = ints.unsigned;
                                        description = "Lifespan of cancelled download tasks.";
                                        defaultText = "(indefinite)";
                                    };
                            };
                        };
                        files = {
                            complete = mkOption {
                                type = ints.unsigned;
                                description = "Lifespan of completely downloaded files in minutes.";
                                example = 20160;
                                defaultText = "(indefinite)";
                            };
                            incomplete = mkOption {
                                type = ints.unsigned;
                                description = "Lifespan of incomplete downloading files in minutes.";
                                defaultText = "(indefinite)";
                            };
                        };
                    };

                    logger = {
                        # Disable by default, journald already retains as needed
                        disk = mkOption {
                            type = bool;
                            description = "Whether to log to the application directory.";
                            default = false;
                            visible = false;
                        };
                    };
                };
            };
        };

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
                description = "use linuxserver/slskd and set a version";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes.resources = let
            appName = "slskd";

            serviceName = "slskd";

            appdataVolumeName = "slskd-appdata";
            configMapName = "slskd-config";
        in {
            deployments.slskd = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    repliacs = 1;
                    strategy.type = "Recreate";
                    selector.matchLabels.app = appName;
                    template = {
                        metadata.labels.app = appName;
                        spec = let
                          appdataVolumeName = "app";
                          configVolumeName = "config";
                          mediaVolumeName = "media";
                        in {
                            containers.slskd = {
                                image = cfg.kubernetes.image;
                                ports = [ 
                                    { 
                                        containerPort = cfg.settings.web.port;
                                    }
                                ];
                                volumeMounts = {
                                    "/app/slskd.yml" = {
                                        name = configVolumeName;
                                        subDir = "slskd.yml";
                                    };
                                    "/app".name = appdataVolumeName;
                                    "/media".name = mediaVolumeName;
                                };
                            };

                            volumes${appdataVolumeName}.persistentVolumeClaim.name = appdataClaimName;
                            volumes.${configVolumeName}.configMap.name = configMapName;
                            volumes.${mediaVolumeName}.persistentVolumeClaim.name = cfg.kubernetes.volumes.media.name;
                        };
                    };
                };
            };

            persistentVolumeClaims.${appdataClaimName} = {
                metadata = {
                    namespace = cfg.kubernetes.namespace;
                    spec = {
                        accessModes = [ "ReadWriteMany" ];
                        storageClassName = "longhorn"; # TODO ?
                    };
                };
            };

            configMaps.${configMapName} = {
                metadata.namespace = cfg.kubernetes.namespace;
                data."slskd.yml" = builtins.readFile configurationYaml;
            };

            services.${serviceName} = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    selector.app = appName;
                    ports = [
                        {
                            port = cfg.settings.web.port;
                            targetPort = cfg.settings.web.port;
                        }
                    ]
                };
            };

            # TODO: make constants for domain names and such
            ingress = {
                slskd = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                            "traefik.ingress.kubernetes.io/router.tls" = "true"; # string, not boolean type.
                        };
                    };
                    spec = {
                        rules."slskd.awesomecooldomain.pp.ua".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };

                slskd-local = {
                    metadata = {
                        namespace = cfg.kubernetes.namespace;
                        annotations = {
                            "kubernetes.io/ingress.class" = "traefik";
                        };
                    };
                    spec = {
                        rules."slskd.local".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                        rules."slskd.homelab".http.paths."/" = {
                            pathType = "Prefix";
                            backend.service.${serviceName}.port.number = httpPort;
                        };
                    };
                };
            };
        };
    };
}