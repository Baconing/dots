{ config, inputs, lib, stateVersion, username, pkgs, ... }:
{
    imports = [
        inputs.sops-nix.homeManagerModule
        ../modules/home
        ./apps
    ];

    home = {
        inherit stateVersion;
        inherit username;

        homeDirectory = if username == "bkfreier" then "/home/campus14/${username}" else "/home/${username}";
    };

    home.packages = with pkgs; [
        fastfetch
        fd
        file
        iperf3
        ripgrep
        htop
        rclone
    ];

    sops = {
        age = {
            keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
            generateKey = false;
        };
    };

    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };

    nixpkgs = {
        config = {
            allowUnfree = true;
        };
    };

    xdg = {
      enable = true;

      configFile."nixpkgs/config.nix".text = ''
        {
            allowUnfree = true;
        }
      '';
    };

    home.sessionVariables = lib.mkIf (username == "bkfreier") {
      PATH = "/home/campus14/bkfreier/.local/bin:/home/campus14/bkfreier/bin:/home/campus14/bkfreier/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/cuda-13.4/bin:/opt/puppetlabs/bin";
      XDG_DATA_DIRS = "/home/campus14/bkfreier/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share/:/usr/share/:/home/campus14/bkfreier/.nix-profile/share:/nix/var/nix/profiles/default/share";
    };

    targets.genericLinux.gpu.enable = lib.mkIf (username == "bkfreier") true;
}
