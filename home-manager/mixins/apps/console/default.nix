{lib, pkgs, ...}: 
{
  imports = [
    ./neovim
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
