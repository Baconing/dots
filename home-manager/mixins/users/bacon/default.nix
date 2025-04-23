{lib, pkgs, ...}:
{
   programs = {
     git = {
       enable = true;
       package = pkgs.gitFull;
       userName = "Baconing";
       userEmail = "iam@baconi.ng";
       extraConfig = {
         pull.rebase = false; # merge when pulling by default
         credential.helper = [
           "oauth"
           "libsecret"
         ];
       };
       signing = {
         key = "AB9ED05142400E418145041918C8F79B0400D766"; # todo: secret or smth?
         signByDefault = true;
       };
     };
   };
}
