{ pkgs, ... }:
{
    imports = [
        ./discord
	./games
	./jetbrains
	./librewolf
	./school
    ];

    home.packages = with pkgs; [
        google-chrome
	termius
	freelens-bin
    ];
}
