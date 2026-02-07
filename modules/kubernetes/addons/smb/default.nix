{ lib, kubenix, config, options, ... }:
let
    cfg = config.addons.smb;
in {
    imports = [
        kubenix.modules.k8s
        kubenix.modules.helm
    ];

    options.addons.smb = {
        enable = lib.mkEnableOption "SMB CSI Driver";
    };

    config = lib.mkIf cfg.enable {
        kubernetes.helm.releases.smb = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts";
                chart = "csi-driver-smb";
                version = "1.19.1";
                sha256 = "3TWGwasCcimmMKE4yGvqvtqS/ag2ZqrhCJUVn0p9aq8=";
            };
        };
    };
}