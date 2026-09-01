{ config, ... }:
{
    sops.secrets.wireguard = {
        sopsFile = ./wireguard.secret.yaml;
    };

    networking.wireguard = {
        enabled = true;
        interfaces.wg0 = {
            ips = ["192.168.10.2/24"];

            listenPort = 51820;

            # public key: lC874VXfC9NDZ00l9Zlje4tAoLkz0pyQq3Woa8J1ugo=
            privateKeyFile = config.sops.secrets.wireguard.private-key;

            peers = [
                {
                    name = "router";
                    publicKey = "6GFSjg8oL/fwBft9tCccaJLATDhtJaPiS4+hRY2GHRg=";
                    endpoint = "direct.saturn.ci";

                    allowedIPs = [
                        "192.168.10.1/24"
                    ];

                    persistentKeepalive = 25;

                    presharedKeyFile = config.sops.secrets.wireguard.preshared-key;
                }
            ]

        };
    };

    networking.firewall = {
        allowedUDPPorts = [ 51820 ];
        trustedInterfaces = [ "wg0" ];
    };
}