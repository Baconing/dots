# TODO: Do not install Java on servers/lightweight machines unless required.

{ pkgs, ... }: 
{
    programs.java.enable = true;

    # Use nix-shell -p jdk* or development flakes, otherwise pkgs.jdk is the default.
    # These are added to keep them downloaded.
    home.packages = with pkgs; [
        jdk8
	jdk11
	jdk17
	jdk21
	jdk25
    ];
}
