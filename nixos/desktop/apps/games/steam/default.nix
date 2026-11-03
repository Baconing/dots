{ pkgs, ... }:
{
    programs.steam = {
    	enable = true;
	extraCompatPackages = with pkgs; [
	    protonplus
	    proton-ge-bin
	    steamtinkerlaunch
	];
    };
}
