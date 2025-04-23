{lib, desktop, pkgs, ...}:
{
  imports = [
    ./${desktop}
  ];

  home.packages = with pkgs;
    [
      google-chrome
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ]; 

}
