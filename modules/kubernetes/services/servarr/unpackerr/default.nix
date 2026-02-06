# TODO: Native Prometheus Metrics (with webserver)

{ lib, kubenix, config, ... }:
let
    cfg = config.kubernetes.services.unpackerr;
in {
    imports = [ kubenix.modules.k8s ];

    options.kubernetes.services.unpackerr = {
        enable = lib.mkEnableOption "Unpackerr Automatic Unarchiver";

        global = {
            interval = lib.mkOption {
                type = lib.types.str;
                description = "How often apps are polled, recommend 1m to 5m.";
                default = "2m";
            };

            startDelay = lib.mkOption {
                type = lib.types.str;
                description = "Files are queued at least this long before extraction.";
                default = "1m";
            };

            retryDelay = lib.mkOption {
                type = lib.types.str;
                description = "Failed extractions are retried after at least this long.";
                default = "5m";
            };

            maxRetries = lib.mkOption {
                type = lib.types.int;
                description = "Failed extractions are retried this many times.";
                default = 3;
            };

            parallel = lib.mkOption {
                type = lib.types.int;
                description = "Concurrent extractions, only recommend 1";
                default = 1;
            };
        };


        # TODO: add support for multiple Sonarr instances.
        sonarr = {
            url = lib.mkOption {
                type = lib.types.str;
                description = "the url of the Sonarr server";
            };

            # TODO: Use Kubernetes Secrets and Unpackerr secret files
            apiKey = lib.mkOption {
                type = lib.types.str;
                description = "the api key for the Sonarr server";
            };

            # TODO: add support for multiple paths
            path = lib.mkOption {
                type = lib.types.str;
                description = "File system path where downloaded items are located.";
                default = "/media/downloads/torrent";
            };

            protocols = lib.mkOption {
                type = lib.types.str;
                description = "Protocols to process. Alt: torrent,usenet";
                default = "torrent";
            };

            deleteDelay = {
                type = lib.types.str;
                description = "Extracts are deleted this long after import, -1s to disable.";
                default = "5m";
            };

            deleteOriginal = lib.mkOption {
                type = lib.types.bool;
                description = "Delete archives after import? Recommend keeping this false.";
                default = false;
            };
        };

        radarr = {
            url = lib.mkOption {
                type = lib.types.str;
                description = "the url of the Radarr server";
            };

            # TODO: Use Kubernetes Secrets and Unpackerr secret files
            apiKey = lib.mkOption {
                type = lib.types.str;
                description = "the api key for the Radarr server";
            };

            # TODO: add support for multiple paths
            path = lib.mkOption {
                type = lib.types.str;
                description = "File system path where downloaded items are located.";
                default = "/media/downloads/torrent";
            };

            protocols = lib.mkOption {
                type = lib.types.str;
                description = "Protocols to process. Alt: torrent,usenet";
                default = "torrent";
            };

            deleteDelay = {
                type = lib.types.str;
                description = "Extracts are deleted this long after import, -1s to disable.";
                default = "5m";
            };

            deleteOriginal = lib.mkOption {
                type = lib.types.bool;
                description = "Delete archives after import? Recommend keeping this false.";
                default = false;
            };
        };

        lidarr = {
            url = lib.mkOption {
                type = lib.types.str;
                description = "the url of the Lidarr server";
            };

            # TODO: Use Kubernetes Secrets and Unpackerr secret files
            apiKey = lib.mkOption {
                type = lib.types.str;
                description = "the api key for the Lidarr server";
            };

            # TODO: add support for multiple paths
            path = lib.mkOption {
                type = lib.types.str;
                description = "File system path where downloaded items are located.";
                default = "/media/downloads/torrent";
            };

            protocols = lib.mkOption {
                type = lib.types.str;
                description = "Protocols to process. Alt: torrent,usenet";
                default = "torrent";
            };

            deleteDelay = {
                type = lib.types.str;
                description = "Extracts are deleted this long after import, -1s to disable.";
                default = "5m";
            };

            deleteOriginal = lib.mkOption {
                type = lib.types.bool;
                description = "Delete archives after import? Recommend keeping this false.";
                default = false;
            };
        };

        # TODO: Watch Folders, Web Hooks, and Command Hooks

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
                description = "use golift/unpackerr and set a version";
            };
        };
    };

    config = lib.mkIf cfg.enable {
        kubernetes.resources = let
        in {
            deployments.unpackerr = {
                metadata.namespace = cfg.kubernetes.namespace;
                spec = {
                    repliacs = 1;
                    strategy.type = "Recreate";
                    template = {
                        spec = let
                          mediaVolumeName = "media";
                        in {
                            containers.unpackerr = {
                                image = cfg.kubernetes.image;
                                environment = {
                                    UN_INTERVAL = cfg.global.interval;
                                    UN_START_DELAY = cfg.global.startDelay;
                                    UN_RETRY_DELAY = cfg.global.retryDelay;
                                    UN_MAX_RETRIES = cfg.global.maxRetries;
                                    UN_PARALLEL = cfg.global.parallel;

                                    UN_SONARR_0_URL = cfg.sonarr.url;
                                    UN_SONARR_0_API_KEY = cfg.sonarr.apiKey;
                                    UN_SONARR_0_PATHS_0 = cfg.sonarr.path;
                                    UN_SONARR_0_PROTOCOLS = cfg.sonarr.protocols;
                                    UN_SONARR_0_DELETE_DELAY = cfg.sonarr.deleteDelay;
                                    UN_SONARR_0_DELETE_ORIG = cfg.sonarr.deleteOriginal;

                                    UN_RADARR_0_URL = cfg.radarr.url;
                                    UN_RADARR_0_API_KEY = cfg.radarr.apiKey;
                                    UN_RADARR_0_PATHS_0 = cfg.radarr.path;
                                    UN_RADARR_0_PROTOCOLS = cfg.radarr.protocols;
                                    UN_RADARR_0_DELETE_DELAY = cfg.radarr.deleteDelay;
                                    UN_RADARR_0_DELETE_ORIG = cfg.radarr.deleteOriginal;

                                    UN_LIDARR_0_URL = cfg.lidarr.url;
                                    UN_LIDARR_0_API_KEY = cfg.lidarr.apiKey;
                                    UN_LIDARR_0_PATHS_0 = cfg.lidarr.path;
                                    UN_LIDARR_0_PROTOCOLS = cfg.lidarr.protocols;
                                    UN_LIDARR_0_DELETE_DELAY = cfg.lidarr.deleteDelay;
                                    UN_LIDARR_0_DELETE_ORIG = cfg.lidarr.deleteOriginal;
                                };
                                volumeMounts = {
                                    "/media".name = mediaVolumeName;
                                };
                            };

                            volumes = {
                                mediaVolumeName.persistentVolumeClaim.name = cfg.kubernetes.volumes.media.name;
                            };
                        };
                    };
                };
            };
        };
    };
}