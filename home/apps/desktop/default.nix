{ pkgs, ... }:
{
    imports = [
        ./discord
	./librewolf
	./games
    ];

    home.packages = with pkgs; [
        google-chrome
    ];
}
