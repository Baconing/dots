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
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9/aKgDkCFCmS2icsuwq17qbZSPwdqwTYQ7pZB4I6qr" ];
    #shell = pkgs.zsh; 
  };
}
