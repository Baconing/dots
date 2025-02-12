{ config, inputs, isDesktop, isISO, lib, outputs, pkgs, stateVersion, username, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    ./mixins
  ];

  home = {
    inherit username;
    home-manager.enable = true;

    homeDirectory = "/home/${username}";

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    nix = {
      package = pkgs.nixVersions.latest;
      settings = {
        experimental-features = "flakes nix-command";
        trusted-users = [
          "root"
          "${username}"
        ];
      };
    };
  };
}
