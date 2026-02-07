{ kubenix, ... }:
{
    imports = [
        kubenix.modules.k8s
        ./jellyfin
        # ./qbittorrent
        # ./servarr
    ];

    kubernetes.resources = let
        mediaPersistentVolumeName = "media";
        downloadsPersistentVolumeName = "media-downloads";
    in {
        namespaces = {
            "media" = {
                metadata = {
                    name = "media";
                };
            };
        };

        persistentVolumes = {
            ${mediaPersistentVolumeName} = {
                metadata = {
                    namespace = "media"; # TODO
                    labels = {
                        name = mediaPersistentVolumeName;
                    };
                };

                spec = {
                    accessModes = [ "ReadWriteMany" ];
                    capacity.storage = "1Pi";
                    storageClassName = "smb";
                    csi = {
                        driver = "smb.csi.k8s.io"; # TODO add smb csi driver
                        volumeHandle = "phoebe.default.svc.cluster.local/media##";
                        volumeAttributes = {
                            source = "//phoebe-truenas.local/media"; # TODO
                        };
                        nodeStageSecretRef = {
                            name = "smb-credentials";  # TODO
                            namespace = "default"; # TODO
                        };
                    };
                };
            };
            ${downloadsPersistentVolumeName} = {
                metadata = {
                    namespace = "media"; # TODO
                    labels = {
                        name = downloadsPersistentVolumeName;
                    };
                };

                spec = {
                    accessModes = [ "ReadWriteMany" ];
                    capacity.storage =  "1Pi";
                    storageClassName = "smb";
                    csi = {
                        driver = "smb.csi.k8s.io"; # TODO add smb csi driver
                        volumeHandle = "phoebe.default.svc.cluster.local/media#downloads#";
                        volumeAttributes = {
                            source = "//phoebe-truenas.local/media"; # TODO
                            subDir = "downloads";
                        };
                        nodeStageSecretRef = {
                            name = "smb-credentials";  # TODO
                            namespace = "default"; # TODO
                        };
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
                    resources.requests.storage = "1Pi";
                    accessModes = [ "ReadWriteMany" ];
                    storageClassName = "smb";
                    volumeName = mediaPersistentVolumeName;
                };
            };

            media-downloads = {
                metadata = {
                    namespace = "media"; # TODO
                };

                spec = {
                    resources.requests.storage = "1Pi";
                    accessModes = [ "ReadWriteMany" ];
                    storageClassName = "smb";
                    volumeName = downloadsPersistentVolumeName;
                };
            };
        };
    };
}