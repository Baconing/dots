{ pkgs, ... }:
{
    home.packages = with pkgs; [
	# Add the Mathematica installer .sh file to the Nix store with:
	# nix-store --add-fixed sha256 <FILE>
	mathematica
    ];
}
