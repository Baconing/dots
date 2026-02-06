{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.smb;
in {
    imports = [ kubenix.modules.k8s ];

    options.addons.smb = {
        enable = lib.mkEnableOption "SMB CSI Driver";
    };

    config = lib.mkIf cfg.enable {
        kubernetes.helm.releases.smb = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts";
                chart = "csi-driver-smb";
                version = "1.19.1";
                sha256 = "55b855a16a5eabb63d7d08bf7632bb520836cf387d942847e0770b2e40600cc1";
            };
        };
    };
}