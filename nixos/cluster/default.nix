{ config, hostname, inputs, lib, clusterRole, clusterTemplate,  ... }: 
{
    imports = [
        inputs.sops-nix.nixosModules.sops
        inputs.nixos-hardware.nixosModules.common-pc
        ../../modules/nixos
    ] ++ lib.optional (clusterTemplate != "") ./template/${clusterTemplate} ++ lib.optional (builtins.pathExists ./node/${hostname}) ./node/${hostname};
  
    boot.loader.efi.efiSysMountPoint = "/boot";

    fileSystems = {
        "/" = {
            device = "/dev/disk/by-label/ROOT";
            fsType = "ext4";
        };
        "/boot" = {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
    };
  
    swapDevices = [
        { 
            device = "/swapfile"; 
        }
    ];

    sops.secrets.kubernetes-token = {
        sopsFile = ./kubernetes.secret.yaml;
        #owner = config.systemd.services.k3s.serviceConfig.user; #todo
        restartUnits = [ "k3s.service" ];
    };

    homelab = {
        services = {
            kubernetes = {
                enable = true;
                role = clusterRole;
                tokenFile = config.sops.secrets.kubernetes-token.path;
                masterAddress = "https://10.10.254.253:6443"; # todo
            };
        };
    };

    services.keepalived = lib.mkIf (clusterRole == "control") {
        enable = true;
        openFirewall = true;

        vrrpInstances.kube_api = {
            state = "BACKUP";
            virtualRouterId = 51;
            priority = 50;
            virtualIps = [ { addr = "10.10.254.253/16"; } ];
        };
    };


    # todo: move to service or smth, also move servers to variable
    services.haproxy = lib.mkIf (clusterRole == "control") {
        enable = true;

        config = ''
            global
                log /dev/log local0
                log /dev/log local1 notice
                daemon
                maxconn 4096

            defaults
                log     global
                mode    tcp
                option  tcplog
                timeout connect 5s
                timeout client  1m
                timeout server  1m

            frontend kubernetes_api
                bind 10.10.254.253:6443
                default_backend kubernetes_api_backends

            backend kubernetes_api_backends
                mode tcp
                balance roundrobin
                option tcp-check
                server skoll skoll.local:6443 check
                server callisto callisto.local:6443 check
                server mneme mneme.local:6443 check
        '';
    };

    boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = lib.mkIf (clusterRole == "control") 1;
}