{lib, pkgs, ...}:
{
   home.sessionVariables = {
     EDITOR = "nvim";
     VISUAL = "nvim";
   };

   programs = {
     git = {
       userName = "Baconing";
       userEmail = "iam@baconi.ng";
       signing = {
         key = "13680859DCD49591"; # todo: secret or smth?
       };
     };
   };
}
