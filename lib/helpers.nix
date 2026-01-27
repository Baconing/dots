{ inputs, outputs, stateVersion }:
{
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

    # Makes a console-only NixOS configuration (e.g servers).
    makeConsoleNixOS = { hostname, isCluster ? false, role ? null, template ? null, platform ? "x86_64-linux" }:
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
            stateVersion
            isDesktop
            isISO
            isCluster;
        };
        modules = [ ../nixos ];
    };

    # Makes a kubernetes cluster node NixOS configuration.
    makeClusterNixOS = { hostname, role, template, platform ? "x86_64-linux" }:
        let
        isCluster = true;
        in
        outputs.makeConsoleNixOS {
        specialArgs = {
            inherit
            hostname
            role
            template
            platform;
        };
        modules = [ ../nixos ];
    };

    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
}