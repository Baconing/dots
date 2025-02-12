{lib, ...}:
{
  home.packages = with pkgs;
    [
      fastfetch
      fd
      file
      iperf3
    ];
}
