{ pkgs, ... }: 
{
    home.packages = with pkgs; [
	jetbrains.clion
	jetbrains.datagrip
	jetbrains.dataspell
	jetbrains.goland
	jetbrains.idea
	jetbrains.pycharm
	jetbrains.rider
	jetbrains.rust-rover
	jetbrains.webstorm
    ];
}
