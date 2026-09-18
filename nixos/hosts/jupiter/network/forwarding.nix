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

                    iifname "ens3" tcp dport 2222 return
                    iifname "ens3" udp dport 51820 return
                    iifname "ens3" ip protocol icmp return
                    iifname "ens3" dnat to 192.168.10.1
                }

                chain postrouting {
                    type nat hook postrouting priority srcnat;

                    oifname "ens3" iifname "wg0" masquerade
                }
            }

            table inet filter {
                chain input {
                    type filter hook input priority filter;
                    policy drop;

                    iifname "lo" accept

                    ct state established,related accept

                    tcp dport 2222 accept
                    udp dport 51820 accept
                    ip protocol icmp accept

                    iifname "wg0" accept
                }

                chain forward {
                    type filter hook forward priority filter;
                    policy drop;

                    ct state established,related accept

                    iifname "ens3" oifname "wg0" accept
                    iifname "wg0" oifname "ens3" accept
                }

                chain output {
                    type filter hook output priority filter;
                    policy accept;
                }
            }
        '';
    };
}