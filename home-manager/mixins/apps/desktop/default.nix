{lib, desktop, pkgs, ...}:
{
  imports = [
    ./${desktop}
    ./thunderbird
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
