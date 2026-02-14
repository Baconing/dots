{ lib, config, pkgs, ... }:
let
  cfg = config.homelab.services.kubernetes;
in {
    options.homelab.services.kubernetes = {
        enable = lib.mkEnableOption "setup kubernetes services and enroll this node into the cluster";

        role = lib.mkOption {
            type = lib.types.enum [ "primary" "control" "node" ];
            default = "node";
        };

        tokenFile = lib.mkOption {
            type = lib.types.path;
        };

        masterAddress = lib.mkOption {
            type = lib.types.str;
        };

        vip = lib.mkOption {
            type = lib.types.str;
            description = "The virtual IP that the server can be accessed from";
        };

        netDev = lib.mkOption {
            type = lib.types.str;
            description = "The primary network device. (to be used for virtual ip)";
        };

        init = lib.mkOption {
            type = lib.types.bool;
            description = "Set this to true when initalizing a new cluster (primary node), or registering a new control plane node.";
            default = false;
        };

        # gpu = lib.mkOption {
        #     type = lib.types.nullOr (lib.types.submodule {
        #         options = {
        #             type = lib.mkOption {
        #                 type = lib.types.enum [ "nvidia" "amd" "intel" ];
        #             };

        #             class = lib.mkOption {
        #                 type = lib.types.enum [ "high" "mid" "low" ];
        #             };

        #             encode = lib.mkOption {
        #                 type = lib.types.listOf lib.types.enum [ "h264" "vc1" "av1" "vp9" "mpeg2video" "vp8" "hevc" ];
        #             };
                    
        #             decode = lib.mkOption {
        #                 type = lib.types.listOf lib.types.enum [ "h264" "vc1" "av1" "vp9" "mpeg2video" "vp8" "hevc" ];
        #             };
        #         };
        #     });
        #     default = null;
        # };

        # taints = lib.mkOption {
        #     type = lib.types.listOf lib.types.str;
        #     default = [];
        # };
    };

    config = lib.mkIf cfg.enable {
        services.k3s = {
            enable = true;

            tokenFile = cfg.tokenFile;

            role =
              if cfg.role == "control" || cfg.role == "primary"
              then "server"
              else "agent";

            # extraKubeletConfig = {
            #     registerWithTaints = cfg.taints;
            # };
        };

        services.k3s.serverAddr = lib.mkIf (cfg.role != "primary" && ((cfg.role == "control" && cfg.init) || cfg.role == "node")) cfg.masterAddress;

        # services.k3s.extraKubeletConfig.nodeLabels = lib.mkIf (cfg.gpu != null) {
        #     gpu = {
        #         type = cfg.gpu.type;
        #         class = cfg.gpu.class;
        #         encode = lib.strings.join "," cfg.gpu.encode;
        #         decode = lib.strings.join "," cfg.gpu.decode;
        #     };
        # };

        services.k3s.extraFlags = lib.mkIf (cfg.role == "primary" || cfg.role == "control") [
            "--tls-san=${cfg.vip}"
            "--advertise-address=${cfg.vip}"
        ];

        services.k3s.clusterInit = lib.mkIf (cfg.role == "primary" && cfg.init) true;

        networking.firewall.allowedTCPPorts = [
            2379 2380 6443 10250
        ];

        networking.firewall.allowedUDPPorts = [
            8472
        ];

        virtualisation.containerd.enable = true;

        environment.systemPackages = with pkgs; [
            nfs-utils
            cifs-utils
        ];

        services.openiscsi = {
            enable = true;
            name = "${config.networking.hostName}-initiatorhost";
        };

        systemd.services.iscsid.serviceConfig = {
            PrivateMounts = "yes";
            BindPaths = "/run/current-system/sw/bin:/bin";
        };

        services.keepalived = lib.mkIf (cfg.role == "primary" || cfg.role == "control") {
            enable = true;
            openFirewall = true;

            vrrpInstances.kube_api = {
                state = if cfg.role == "primary" then "MASTER" else "BACKUP";
                virtualRouterId = 51;
                priority = if cfg.role == "primary" then 100 else 50;
                virtualIps = [ 
                    {
                        addr = "${cfg.vip}/32";
                        dev = "${cfg.netDev}";
                        label = "${cfg.netDev}:kube";
                    }
                ];
                interface = cfg.netDev;
                extraConfig = ''
                    notify_master "/run/current-system/sw/bin/systemctl start haproxy"
                    notify_backup "/run/current-system/sw/bin/systemctl stop haproxy"
                    notify_fault  "/run/current-system/sw/bin/systemctl stop haproxy"
                '';
            };
        };

        boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = lib.mkIf (cfg.role == "primary" || cfg.role == "control") 1;

        services.haproxy = lib.mkIf (cfg.role == "primary" || cfg.role == "control") {
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
                    bind ${cfg.vip}:6443
                    default_backend kubernetes_api_backends

                backend kubernetes_api_backends
                    mode tcp
                    balance roundrobin
                    option tcp-check
                    server skoll 10.10.3.1:6443 check
                    server callisto 10.10.5.1:6443 check
                    server mneme 10.10.5.2:6443 check
            '';
        };
    };
}
