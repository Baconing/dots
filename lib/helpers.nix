{ inputs, outputs, stateVersion }:
{
    # Makes a console-only NixOS configuration.
    makeNixOS = { hostname, desktop ? false, clustered ? false, clusterRole ? "", clusterTemplate ? "", clusterIP ? "", platform ? "x86_64-linux" }: inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
            inherit
            hostname
            desktop
	    clustered
            clusterRole
            clusterTemplate
            clusterIP
            platform
            stateVersion
            inputs
            outputs;
        };
        modules = [ 
	    ../nixos
	];
    };

    # Makes a  home manager configuration.
    makeHome = { hostname, username, desktop ? false, platform ? "x86_64-linux" }: inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${platform};
        extraSpecialArgs = {
            inherit
            hostname
            username
            desktop
            platform
            inputs
            outputs
            stateVersion;
        };
        modules = [ 
	    ../home 
	];
    };

    forAllSystems = inputs.nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch64-linux"
    ];
}
