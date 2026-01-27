{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      git-credential-oauth
    ];

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      extraConfig = {
        pull.rebase = false;
        credential.helper = [
          "oauth"
          "libsecret"
        ];
      };
      signing = {
        signByDefault = true;
      };
    };
  };
}