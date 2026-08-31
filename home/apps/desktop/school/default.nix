
{ pkgs, ... }:
{
    imports = [
        # ./mathematica # TODO: does not detect installer files.
    ];

    home.packages = with pkgs; [
	logisim-evolution
	quartus-prime-lite
    ];
}
