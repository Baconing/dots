{ pkgs, ... }:
{
  programs.gpg = {
    enable = true;
    settings = {
      use-agent = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-curses;
  };
}