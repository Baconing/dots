{ inputs, outputs, stateVersion, ... }:

{
  # Makes a home manager environment with a desktop environment.
  makeDesktopHome = { hostname, username, desktop, displayManager, platform ? "x86_64-linux" }:
    let 
      isDesktop = true;
      isISO = false;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          desktop
	  displayManager
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules = [ ../home-manager ];
  };

  # Makes a console-only home manager configuration (e.g servers).
  makeConsoleHome = { hostname, username, platform ? "x86_64-linux" }:
    let
      isDesktop = false;
      isISO = false;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules = [ ../home-manager ];
  };

  # Makes a home manager environment with a desktop environment for an ISO file.
  makeDesktopISOHome = { hostname, username, desktop, displayManager, platform ? "x86_64-linux" }:
    let 
      isDesktop = true;
      isISO = true;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          desktop
          displayManager
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules = [ ../home-manager ];
  };

  # Makes a console-only home manager configuration for an ISO file.
  makeConsoleISOHome = { hostname, username, platform ? "x86_64-linux" }:
    let
      isDesktop = false;
      isISO = true;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit
          inputs
          outputs
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules = [ ../home-manager ];
  };


  # Makes a NixOS configuration with a destkop environment.
  makeDesktopNixOS = { hostname, username, desktop, displayManager, platform ? "x86_64-linux" }:
    let
      isDesktop = true;
      isISO = false;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          displayManager
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules = [ ../nixos ];
  };


  # Makes a console-only NixOS configuration (e.g servers).
  makeConsoleNixOS = { hostname, username, platform ? "x86_64-linux" }:
    let
      isDesktop = false;
      isISO = false;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules = [ ../nixos ];
  };

  # Makes a NixOS bootable ISO installer with a destkop environment.
  makeDesktopNixOSISO = { hostname, username, desktop, displayManager, platform ? "x86_64-linux" }:
    let
      isDesktop = true;
      isISO = true;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          desktop
          displayManager
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules =
        let
          cd-dvd = inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        in
          [ ../nixos cd-dvd ];
  };

  # Makes a console-only NixOS ISO installer.
  makeConsoleNixOSISO = { hostname, username, platform ? "x86_64-linux" }:
    let
      isDesktop = false;
      isISO = true;
    in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          outputs
          hostname
          platform
          username
          stateVersion
          isDesktop
          isISO;
      };
      modules =
        let
          cd-dvd = inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";
        in
          [ ../nixos cd-dvd ];
  };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}
