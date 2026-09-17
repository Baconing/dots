{ lib, ... }:
{
    boot.initrd.availableKernelModules = [
        "uhci_hcd"
	"virtio_pci"
    ];

    boot.kernelModules = [ "kvm-intel" ];

    imports = [
        ./disks.nix
        ./network
    ];

    boot.loader = {
        efi = {
	    canTouchEfiVariables = lib.mkForce false;
	};
	grub = {
	    efiSupport = lib.mkForce false;
	};
    };

    services.openssh.ports = [ 2222 ];
}
