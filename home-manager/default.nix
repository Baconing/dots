{ config, inputs, isDesktop, isISO, lib, outputs, pkgs, stateVersion, username, ... }:
let
  inherit (pkgs.stdenv) isLinux;
in
{
  imports = [
    ./mixins
  ];

  home = {
    inherit stateVersion;
    inherit username;

    homeDirectory = "/home/${username}";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
}
