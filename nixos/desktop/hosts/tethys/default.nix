{ inputs, ... }:
{
    imports = [
        inputs.nixos-hardware.nixosModules.common-pc-laptop
        inputs.nixos-hardware.nixosModules.common-pc-ssd
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    ];

    hardware.nvidia = {
        open = true;
        prime = {
            intelBusId = "PCI:0@0:2:0";
     	    nvidiaBusId = "PCI:1@0:0:0";

	    offload = {
	        enable = true;
		enableOffloadCmd = true;
	    };
    	};
    };

    boot.kernelParams = [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
	"nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];
}
