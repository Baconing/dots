{ lib, pkgs, config, ... }:
{
  environment.localBinInPath = true;

  sops.secrets.root-password = {
    sopsFile = ./user.secret.yaml;
    neededForUsers = true;
  };

  sops.secrets.bacon-password = {
    sopsFile = ./user.secret.yaml;
    neededForUsers = true;
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };

  users.users.bacon = {
    extraGroups = [
      "input"
      "users"
      "wheel"
    ];
    homeMode = "0755";
    isNormalUser = true;
    packages = [ pkgs.home-manager ];
    hashedPasswordFile = config.sops.secrets.bacon-password.path;
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII9/aKgDkCFCmS2icsuwq17qbZSPwdqwTYQ7pZB4I6qr" ];
    #shell = pkgs.zsh; 
  };
}
