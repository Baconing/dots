{ kubenix, ... }:
{
    imports = [
        kubenix.modules.k8s
        # ./jellyfin
        # ./qbittorrent
        # ./servarr
    ];

    kubernetes.resources = let
        mediaPersistentVolumeName = "media";
        downloadsPersistentVolumeName = "media-downloads";
     {
        persistentVolumes = {
            ${mediaPersistentVolumeName} = {
                metadata = {
                    namespace = "media"; # TODO
                    labels = {
                        name = mediaPersistentVolumeName;
                    }
                };

                spec = {
                    accessModes = [ "ReadWriteMany" ];
                    csi = {
                        driver = "smb.csi.k8s.io"; # TODO add smb csi driver
                        volumeHandle = "smb-pv";
                        volumeAttributes = {
                            source = "//server/media"; # TODO
                        };
                        nodeStageSecretRef = {
                            name = "smb-credentials";  # TODO
                            namespace = "default"; # TODO
                        }
                    };
                };
            };
            ${downloadsPersistentVolumeName} = {
                metadata = {
                    namespace = "media"; # TODO
                    labels = {
                        name = downloadsPersistentVolumeName;
                    }
                };

                spec = {
                    accessModes = [ "ReadWriteMany" ];
                    csi = {
                        driver = "smb.csi.k8s.io"; # TODO add smb csi driver
                        volumeHandle = "smb-pv";
                        volumeAttributes = {
                            source = "//server/media"; # TODO
                            subDir = "downloads";
                        };
                        nodeStageSecretRef = {
                            name = "smb-credentials";  # TODO
                            namespace = "default"; # TODO
                        }
                    };
                };
            };
        };

        persistentVolumeClaims = {
            media = {
                metadata = {
                    namespace = "media"; # TODO
                };

                spec = {
                    accessModes = [ "ReadWriteMany" ];
                    selector = {
                        matchLabels = {
                            name = mediaPersistentVolumeName
                        };
                    };
                };
            };

            media-downloads = {
                metadata = {
                    namespace = "media"; # TODO
                };

                spec = {
                    accessModes = [ "ReadWriteMany" ];
                    selector = {
                        matchLabels = {
                            name = downloadsPersistentVolumeName;
                        };
                    };
                };
            }
        };
    };
}