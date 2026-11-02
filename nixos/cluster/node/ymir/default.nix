{ config, hostname, inputs, lib, clusterRole, template, pkgs,  ... }: {
    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
    ];

    # homelab.services.kubernetes.netDev = "???";

    boot.initrd = {
        availableKernelModules = [
            "iscsi_tcp"
            "igb"
        ];

        network = {
            enable = true;
            flushBeforeStage2 = false;
        };

        preDeviceCommands = ''
          echo "Setting up iSCSI initiator name..."
          echo "InitiatorName=://iqn.2025-4.ng.baconi:phoebe" > /etc/iscsi/initiatorname.iscsi

          echo "Bringing up network interface..."
          ip link set eth0 up
          udhcpc -i eth0

          echo "Connecting to iSCSI target..."
          iscsistart -i ://iqn.2025-4.ng.baconi:phoebe -t ://iqn.2025-4.ng.baconi:phoebe:ymir -a phoebe-truenas.local
        '';
    };
}