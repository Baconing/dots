#todo: mostly stolen from wimpy's
{
  config,
  desktop,
  isISO,
  isDesktop,
  lib,
  pkgs,
  username,
  ...
}:
let
  isDesktopISO = isISO && isDesktop;
in
{
  config.users.users.nixos.description = "NixOS";

  # All configurations for live media are below:
  config.system = lib.mkIf isISO { stateVersion = lib.mkForce lib.trivial.release; };

  config.environment = {
    etc = lib.mkIf isDesktopISO {
      "firefox.dockitem".source = pkgs.writeText "firefox.dockitem" ''
        [PlankDockItemPreferences]
        Launcher=file:///run/current-system/sw/share/applications/firefox.desktop
      '';
      "firefox.dockitem".target = "/plank/firefox.dockitem";

      "io.elementary.files.dockitem".source = pkgs.writeText "io.elementary.files.dockitem" ''
        [PlankDockItemPreferences]
        Launcher=file:///run/current-system/sw/share/applications/io.elementary.files.desktop
      '';
      "io.elementary.files.dockitem".target = "/plank/io.elementary.files.dockitem";

      "io.elementary.terminal.dockitem".source = pkgs.writeText "io.elementary.terminal.dockitem" ''
        [PlankDockItemPreferences]
        Launcher=file:///run/current-system/sw/share/applications/io.elementary.terminal.desktop
      '';
      "io.elementary.terminal.dockitem".target = "/plank/io.elementary.terminal.dockitem";

      "gparted.dockitem".source = pkgs.writeText "gparted.dockitem" ''
        [PlankDockItemPreferences]
        Launcher=file:///run/current-system/sw/share/applications/gparted.desktop
      '';
      "gparted.dockitem".target = "/plank/gparted.dockitem";
    };
    systemPackages = lib.optionals isDesktopISO [ pkgs.gparted ];
  };

  # All workstation configurations for live media are below.
  config.isoImage = lib.mkIf isDesktopISO { edition = lib.mkForce "${desktop}"; };

  config.programs = {
    dconf.profiles.user.databases = [
      {
        settings =
          with lib.gvariant;
          lib.mkIf isDesktopISO {
            "net/launchpad/plank/docks/dock1" = {
              dock-items = [
                "firefox.dockitem"
                "io.elementary.files.dockitem"
                "io.elementary.terminal.dockitem"
                "gparted.dockitem"
              ];
            };
            "org/gnome/shell" = {
              disabled-extensions = mkEmptyArray type.string;
              favorite-apps = [
                "firefox.desktop"
                "org.gnome.Nautilus.desktop"
                "org.gnome.Console.desktop"
                "io.calamares.calamares.desktop"
                "gparted.desktop"
              ];
              welcome-dialog-last-shown-version = "9999999999";
            };
          };
      }
    ];
  };

  config.services  = {
    displayManager.autoLogin = lib.mkIf isDesktopISO { user = "${username}"; };
  };

  # Create desktop shortcuts and dock items for the live media
  config.systemd.tmpfiles = lib.mkIf isDesktopISO {
    rules =
      [
        "d /home/${username}/Desktop 0755 ${username} users"
        "d /home/${username}/.config 0755 ${username} users"
        "d /home/${username}/.config/plank 0755 ${username} users"
        "d /home/${username}/.config/plank/dock1 0755 ${username} users"
        "d /home/${username}/.config/plank/dock1/launchers 0755 ${username} users"
        "L+ /home/${username}/.config/plank/dock1/launchers/firefox.dockitem - - - - /etc/plank/firefox.dockitem"
        "L+ /home/${username}/.config/plank/dock1/launchers/io.elementary.files.dockitem - - - - /etc/plank/io.elementary.files.dockitem"
        "L+ /home/${username}/.config/plank/dock1/launchers/io.elementary.terminal.dockitem - - - - /etc/plank/io.elementary.terminal.dockitem"
        "L+ /home/${username}/.config/plank/dock1/launchers/gparted.dockitem - - - - /etc/plank/gparted.dockitem"
        "L+ /home/${username}/Desktop/firefox.desktop - - - - ${pkgs.firefox}/share/applications/firefox.desktop"
        "L+ /home/${username}/Desktop/io.calamares.calamares.desktop - - - - ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop"
        "L+ /home/${username}/Desktop/gparted.desktop - - - - ${pkgs.gparted}/share/applications/gparted.desktop"
      ]
  };
}
