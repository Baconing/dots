_:
{
    boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
    };

    networking.nftables = {
        enable = true;
        ruleset = ''
            table ip nat {
                chain prerouting {
                    type nat hook prerouting priority dstnat;

                    iifname "eth0" tcp dport 2222 return
                    iifname "eth0" dnat to 10.254.0.1
                }

                chain postrouting {
                    type nat hook postrouting priority srcnat;

                    oifname "eth0" masquerade
                }
            }

            table inet filter {
                chain input {
                    type filter hook input priority filter;
                    policy drop;

                    iifname "lo" accept

                    ct state established,related accept

                    tcp dport 2222 accept

                    iifname "wg0" accept
                }

                chain forward {
                    type filter hook forward priority filter;
                    policy drop;

                    ct state established,related accept

                    iifname "eth0" oifname "wg0" accept
                    iifname "wg0" oifname "eth0" accept
                }

                chain output {
                    type filter hook output priority filter;
                    policy accept;
                }
            }
        '';
    };
}