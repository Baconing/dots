{ lib, pkgs, ... }:
{
  services = {
    displayManager = {
      plasma6 = {
        enable = true;
      };
    };
  };
}
