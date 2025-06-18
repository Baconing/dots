{lib, pkgs, ...}: 
{
  imports = [
    ./neovim
    ./git
    ./gnupg
    ./bash
  ];

  home.packages = with pkgs;
    [
      fastfetch
      fd
      file
      iperf3
      ripgrep
      htop
      rclone
    ];
}
