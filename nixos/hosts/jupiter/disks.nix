{ lib, ... }:
{
    boot.initrd.availableKernelModules = [
	"ata_piix"
	"virtio_scsi"
	"sd_mod"
    ];

    swapDevices = [
        { 
            device = "/swapfile";
	    size = 8 * 1024; # 8 GiB
        }
    ];

    disko.devices = {
        disk = {
	    main = {
	        device = lib.mkDefault "/dev/sda";
	        type = "disk";
	        content = {
	            type = "gpt";
		    partitions = {
		        boot = {
			    size = "1M";
			    type = "EF02";
			    attributes = [ 0 ];
		        };
		        root = {
			    size = "100%";
			    content = {
			        type = "filesystem";
			        format = "ext4";
			        mountpoint = "/";
			    };
		        };
		    };
	    	};
	    };
	};
    };
}
