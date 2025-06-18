{desktop, pkgs, ...}:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = with pkgs;
      if desktop == "plasma" then
        pinentry-qt
      else
        pinentry-curses;
  };
}
