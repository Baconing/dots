{lib, ...}:
{
   programs = {
     git = {
       enable = true;
       userName = "Baconing";
       userEmail = "iam@baconi.ng";
       extraConfig = {
         credential.helper = "oauth";
       };
       signing = {
         key = "AB9ED05142400E418145041918C8F79B0400D766"; # todo: secret or smth?
         signByDefault = true;
       };
     };
   };
}
