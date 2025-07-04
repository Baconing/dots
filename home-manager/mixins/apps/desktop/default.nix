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
      fluffychat
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "fluffychat-linux-1.22.1"
    "olm-3.2.16"
  ];
}
