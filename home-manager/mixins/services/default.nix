{ lib, isDesktop, ... }:
{
  imports = [ ./console ] ++ lib.optional isDesktop ./desktop;
}
