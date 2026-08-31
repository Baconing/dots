{ pkgs, ... }:
{
    home.packages = with pkgs; [
	# Add the Mathematica installer .sh file to the Nix store with:
	# nix-store --add-fixed sha256 <FILE>
	(mathematica.override {
	    version = "15.0.1";
	    webdoc = false;
	})
    ];
}
