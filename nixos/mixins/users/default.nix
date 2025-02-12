{lib, pkgs, username, ...}:
{
  imports = [
    ./root
    ./{username}
  ];

  environment.localBinInPath = true;

  users.users.${username} = {
    extraGroups = [
      "input"
      "users"
      "wheel"
    ];
    homeMode = "0755";
    isNormalUser = true;
    packages = [ pkgs.home-manager ];
    #shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.userPassword.path;
  };
};
