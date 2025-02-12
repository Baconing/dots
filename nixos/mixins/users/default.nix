{lib, pkgs, username, config, isISO, ...}:
{
  imports = [
    #./root
    ./${username}
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
    hashedPasswordFile = lib.mkIf (!isISO) config.sops.secrets.userPassword.path;
    initialHashedPassword = lib.mkForce null; # For some reason it's defaulting to ""
  };
}
