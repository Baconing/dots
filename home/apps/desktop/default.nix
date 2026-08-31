{ pkgs, ... }:
{
    imports = [
        ./discord
	./games
	./librewolf
	./school
    ];

    home.packages = with pkgs; [
        google-chrome
	termius
	freelens-bin
    ];
}
