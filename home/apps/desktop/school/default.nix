
{ pkgs, ... }:
{
    imports = [
        ./mathematica
    ];

    home.packages = with pkgs; [
	logisim-evolution
	quartus-prime-lite
    ];
}
