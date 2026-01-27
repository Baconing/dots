{ lib, pkgs, config, ... }:
{
  environment.localBinInPath = true;

  users.users.bacon = {
    extraGroups = [
      "input"
      "users"
      "wheel"
    ];
    homeMode = "0755";
    isNormalUser = true;
    packages = [ pkgs.home-manager ];
    #shell = pkgs.zsh; 
  };
}
