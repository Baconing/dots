{ lib, ... }:
{
    disko.devices = {
        disk = {
            main = {
                device = lib.mkDefault "/dev/disk/by-path/ip-phoebe-truenas.local-iscsi-iqn.2025-4.ng.baconi:phoebe-lun-ymir"; # TODO: i have no idea if this is correct.
                type = "disk";
                content = {
                    type = "gpt";
                    partitions = {
                        root = {
                            size = "100%";
                            content = {
                                type = "filesystem";
                                format = "ext4";
                                mountpoint = "/";
                            };
                        };
                    };
                };
            };
        };
    };
}
