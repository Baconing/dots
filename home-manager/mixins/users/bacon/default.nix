{lib, pkgs, ...}:
{
   programs = {
     git = {
       userName = "Baconing";
       userEmail = "iam@baconi.ng";
       signing = {
         key = "AB9ED05142400E418145041918C8F79B0400D766"; # todo: secret or smth?
       };
     };
   };
}
