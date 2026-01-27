{
  description = "Bacon's NixOS & Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    kubenix.url = "github:hall/kubenix";
  };

  outputs = 
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "25.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      homeConfigurations = {
        "bacon@test1" = helper.makeDesktopHome {
          hostname = "test1";
          username = "bacon";
        };
        "bacon@test2" = helper.makeConsoleHome {
          hostname = "test2";
          username = "bacon";
        };

        "bacon@skoll" = helper.makeConsoleHome {
          hostname = "skoll";
          username = "bacon";
        };

        "bacon@hyperion" = helper.makeConsoleHome {
          hostname = "hyperion";
          username = "bacon";
        };

        "bacon@phoebe" = helper.makeConsoleHome {
          hostname = "phoebe";
          username = "bacon";
        };

        "bacon@aitne" = helper.makeConsoleHome {
          hostname = "aitne";
          username = "bacon";
        };

        "bacon@mneme" = helper.makeConsoleHome {
          hostname = "mneme";
          username = "bacon";
        };
        "bacon@eukelade" = helper.makeConsoleHome {
          hostname = "eukelade";
          username = "bacon";
        };
        "bacon@harpalyke" = helper.makeConsoleHome {
          hostname = "harpalyke";
          username = "bacon";
        };
        "bacon@kore" = helper.makeConsoleHome {
          hostname = "kore";
          username = "bacon";
        };
        "bacon@iocaste" = helper.makeConsoleHome {
          hostname = "iocaste";
          username = "bacon";
        };
      };

      nixosConfigurations = {
        skoll = helper.makeClusterNixOS {
            hostname = "skoll";
            template = null;
            role = "control";
        };

        aitne = helper.makeClusterNixOS {
            hostname = "aitne";
            template = null;
            role = "node";
        };

        mneme = helper.makeClusterNixOS {
            hostname = "mneme";
            template = "m73";
            role = "control";
        };
        eukelade = helper.makeClusterNixOS {
            hostname = "eukelade";
            template = "m73";
            role = "node";
        };
        harpalyke = helper.makeClusterNixOS {
            hostname = "harpalyke";
            template = "m73";
            role = "node";
        };
        kore = helper.makeClusterNixOS {
            hostname = "kore";
            template = "m73";
            role = "node";
        };
        iocaste = helper.makeClusterNixOS {
            hostname = "iocaste";
            template = "m73";
            role = "node";
        };

       
      };

      kubenix = inputs.kubenix.packages.${nixpkgs.system}.default.override {
        module = import ./kubernetes;
        specialArgs = { flake = self; };
      };

      # todo: stolen from wimpysworld, idk what these really mean tbh
      overlays = import ./overlays { inherit inputs; };
      nixosModules = import ./modules/nixos;
      homeModules = import ./modules/home;
      #formatter = helper.forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
