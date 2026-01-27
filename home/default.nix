{ config, inputs, lib, stateVersion, username, ... }:
{
    imports = [
        inputs.sops-nix.homeManagerModule
        ../modules/home
        ./apps
    ];

    home = {
        inherit stateVersion;
        inherit username;

        homeDirectory = "/home/${username}";
    };

    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
        fastfetch
        fd
        file
        iperf3
        ripgrep
        htop
        rclone
        nerdfonts
    ];

    sops = {
        age = {
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
            generateKey = false;
        };
    };


    nixpkgs = {
        config = {
            allowUnfree = true;
        };
    };
}