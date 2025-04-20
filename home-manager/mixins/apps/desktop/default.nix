{lib, desktop, pkgs, ...}:
{
  imports = [
    ./${desktop}
  ];

  home.packages = with pkgs;
    [
      firefox
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    ]; 

}
