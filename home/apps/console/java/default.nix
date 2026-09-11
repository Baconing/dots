# TODO: Do not install Java on servers/lightweight machines unless required.

{ pkgs, ... }: 
{
    programs.java = {
        enable = true;
	package = pkgs.jdk21;
    };
}
