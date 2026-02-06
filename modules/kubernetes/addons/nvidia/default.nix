{ lib, kubenix, config, ... }:
let
    cfg = config.addons.nvidia;
in {
    imports = [ kubenix.modules.k8s ];

    options.addons.nvidia = {
        enable = lib.mkEnableOption "NVIDIA GPU Operator";
    };

    config = lib.mkIf cfg.enable {
        kubernetes.helm.releases.nvidia = {
            chart = kubenix.lib.helm.fetch {
                repo = "https://helm.ngc.nvidia.com/nvidia";
                chart = "gpu-operator";
                version = "25.10.1";
                sha256 = "9532cc4dd59248e0eb2a0cd4baa6a7e8ed4258b5d7588ae9c13f5c839482efe5";
            };
        };
    };
}