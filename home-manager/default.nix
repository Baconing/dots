{ config, inputs, isDesktop, isISO, lib, stateVersion, username, ... }:
{
  imports = [
    inputs.sops-nix.homeManagerModule
    ./mixins
  ];

  home = {
    inherit stateVersion;
    inherit username;

    homeDirectory = "/home/${username}";
  };


  sops = lib.mkIf (!isISO) {
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
