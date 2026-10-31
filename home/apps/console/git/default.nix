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
        user =  {
          name = "Brenden (Baconing) Freier";
	        email = "iam@baconi.ng";
	      };
	      push.autoSetupRemote = true;
        pull.rebase = false;
        credential = {
          helper = [
            "cache --timeout 21600"
            "oauth"
            "libsecret"
          ];
          bitbucketAuthModes = "oauth";
        };
      };
      signing = {
        signByDefault = true;
      };
    };
  };
}
