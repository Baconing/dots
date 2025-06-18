{lib, desktop, pkgs, ...}:
{
  imports = [
    ./${desktop}
  ];

  home.packages = with pkgs;
    [
      google-chrome
      spotify
      termius
      discord
      #(discord.override {
      #  withOpenASAR = true;
      #  withVencord = true;
      #})
    ]; 

}
