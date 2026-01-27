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
    makeConsoleNixOS = { hostname, clustered ? false, clusterRole ? "", clusterTemplate ? "", platform ? "x86_64-linux" }:
        inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
            inherit
            hostname
            platform
            clusterRole
            clusterTemplate
            clustered
            stateVersion
            inputs
            outputs;
        };
        modules = [ ../nixos ];
    };

    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];
}