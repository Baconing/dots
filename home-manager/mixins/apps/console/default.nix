{lib, pkgs, ...}: 
{
  imports = [
    ./neovim
    ./git
  ];

  home.packages = with pkgs;
    [
      fastfetch
      fd
      file
      iperf3
      ripgrep
      gnupg
    ];
}
