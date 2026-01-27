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

    colmena.url = "github:zhaofengli/colmena";
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
            clustered = true;
            clusterRole = "control";
        };

        aitne = helper.makeClusterNixOS {
            hostname = "aitne";
            clustered = true;
            clusterRole = "node";
        };

        mneme = helper.makeConsoleNixOS {
            hostname = "mneme";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
        eukelade = helper.makeConsoleNixOS {
            hostname = "eukelade";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
        harpalyke = helper.makeConsoleNixOS {
            hostname = "harpalyke";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
        kore = helper.makeConsoleNixOS {
            hostname = "kore";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
        iocaste = helper.makeConsoleNixOS {
            hostname = "iocaste";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
      };

      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        };

        skoll = {
          deployment.targetHost = "skoll.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.skoll;
        };

        aitne = {
          deployment.targetHost = "aitne.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.aitne;
        };

        mneme = {
          deployment.targetHost = "mneme.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.mneme;
        };

        eukelade = {
          deployment.targetHost = "eukelade.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.eukelade;
        };

        harpalyke = {
          deployment.targetHost = "harpalyke.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.harpalyke;
        };

        kore = {
          deployment.targetHost = "kore.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.kore;
        };

        iocaste = {
          deployment.targetHost = "iocaste.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.iocaste;
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
