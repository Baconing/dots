{ inputs, outputs, stateVersion, ... }:
let
  helpers = import ./helpers.nix { inherit inputs outputs stateVersion; };
in
{
  inherit (helpers)
    makeDesktopHome
    makeConsoleHome
    makeDesktopISOHome
    makeConsoleISOHome
    makeDesktopNixOS
    makeConsoleNixOS
    makeDesktopNixOSISO
    makeConsoleNixOSISO
    forAllSystems;
}