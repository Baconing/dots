{
  description = "Bacon's NixOS & Home Manager Configuration";

  inputs = {
    # NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github.com/nixos/nixos-hardware/master";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = 
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      homeConfigurations = {
        "nixos@iso-console" = helper.makeConsoleISOHome {
          hostname = "iso-console";
          username = "nixos";
        };
        "nixos@iso-plasma" = helper.makeDesktopISOHome {
          hostname = "iso-plasma";
          username = "nixos";
          desktop = "plasma";
        };

        "bacon@titan" = helper.makeDesktopHome {
          hostname = "titan";
          username = "bacon";
          desktop = "plasma";
        };
        "bacon@artemis" = helper.makeDesktopHome {
          hostname = "artemis";
          username = "bacon";
          desktop = "plasma";
        };
      };

      nixosConfigurations = {
        iso-console = helper.makeConsoleNixOSISO {
          hostname = "iso-console";
          username = "nixos";
        };
        iso-plasma = helper.makeDesktopNixOSISO {
          hostname = "iso-plasma";
          username = "nixos";
        };

        titan = helper.makeDesktopNixOS {
          hostname = "titan";
          username = "bacon";
          desktop = "plasma";
        };
        artemis = helper.makeDesktopNixOS {
          hostname = "artemis";
          username = "bacon";
          desktop = "plasma";
        };
      };

      # todo: stolen from wimpysworld, idk what these really mean tbh
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      #packages = helper.forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      #formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
