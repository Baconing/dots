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
      lfs.enable = true;
      settings = {
        user = {
          name = "Brenden Freier";
	  email = "iam@baconi.ng";
	};
	push.autoSetupRemote = true;
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
