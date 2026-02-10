{ lib, config, pkgs, ... }:
let
  cfg = config.homelab.services.kubernetes;
in {
    options.homelab.services.kubernetes = {
        enable = lib.mkEnableOption "setup kubernetes services and enroll this node into the cluster";

        role = lib.mkOption {
            type = lib.types.enum [ "control" "node" ];
            default = "node";
        };

        tokenFile = lib.mkOption {
            type = lib.types.path;
        };

        masterAddress = lib.mkOption {
            type = lib.types.nullOr (lib.types.str);
        };

        vip = lib.mkOption {
            type = lib.types.str;
            description = "The virtual IP that the server can be accessed from";
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
              if cfg.role == "control"
              then "server"
              else "agent";

            extraFlags = [
                "--tls-san=${cfg.vip}"
            ] ++ lib.optional (cfg.role == "control") "--advertise-address=${cfg.vip}";

            # extraKubeletConfig = {
            #     registerWithTaints = cfg.taints;
            # };
        };

        services.k3s.serverAddr = lib.mkIf (cfg.masterAddress != null) cfg.masterAddress;

        # services.k3s.extraKubeletConfig.nodeLabels = lib.mkIf (cfg.gpu != null) {
        #     gpu = {
        #         type = cfg.gpu.type;
        #         class = cfg.gpu.class;
        #         encode = lib.strings.join "," cfg.gpu.encode;
        #         decode = lib.strings.join "," cfg.gpu.decode;
        #     };
        # };


        networking.firewall.allowedTCPPorts = [
            6443 10250
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
    };
}
