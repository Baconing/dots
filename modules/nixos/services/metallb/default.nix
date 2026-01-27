# todo: can proabbly just deploy this in kubernetes? idk

{ lib, pkgs, config, ... }:
let
  cfg = config.homelab.services.metallb;

  metallbNative = (builtins.readFile ./kubernetes/metallb-native.yaml);
  kubernetesConfig = pkgs.replaceVars {
    src = ./kubernetes/config.yaml.tpl;

    addrStart = cfg.pool.start;
    addrEnd = cfg.pool.end;
  };
in
{
    options.homelab.services.metallb = {
        enable = lib.mkEnableOption "metallb (kubernetes)";

        pool = {
            start = lib.mkOption {
                type = lib.type.str;
            };

            end = lib.mkOption {
                type = lib.type.str;
            };
        };
    };

    config = lib.mkIf cfg.enable {
        services.k3s.manifests.metallb-native = {
            enable = true;
            source = pkgs.writeText "metallb-native.yaml" metallbNative;
        };

        services.k3s.manifests.metallb-service = {
            enable = true;
            source = pkgs.writeText "metallb-service.yaml" (builtins.toString kubernetesConfig);
        };
    };
}
