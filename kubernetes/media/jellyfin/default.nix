{ kubenix, ... }:
{
    imports = [ kubenix.modules.k8s ];

    services.jellyfin = {
        enable = true;

        kubernetes = {
            volumes.media.name = "media";

            image = "linuxserver/jellyfin:10.11.6";
        };
    };
}