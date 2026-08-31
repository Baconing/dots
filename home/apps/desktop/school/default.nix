
{ pkgs, ... }:
{
    home.packages = with pkgs; [
	logisim-evolution
    	
	# Add the Mathematica installer .sh file to the Nix store with:
	# nix-store --add-fixed sha256 <FILE>
	mathematica

	quartus-prime-lite
    ];
}
