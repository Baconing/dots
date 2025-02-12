{ config, inputs, isDesktop, isISO, lib, outputs, pkgs, stateVersion, username, ... }:
{
  imports = [
    ./apps
    ./features
    ./scripts
    ./services
    ./users
  ];
}
