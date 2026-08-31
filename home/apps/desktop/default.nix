{ pkgs, ... }:
{
    imports = [
        ./discord
	./games
	./jetbrains
	./joplin
	./librewolf
	./school
    ];

    home.packages = with pkgs; [
        google-chrome
	termius
	freelens-bin
    ];
}
