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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

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

        "bacon@callisto" = helper.makeConsoleHome {
          hostname = "callisto";
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
        skoll = helper.makeConsoleNixOS {
            hostname = "skoll";
            clustered = true;
            clusterRole = "control";
        };

        aitne = helper.makeConsoleNixOS {
            hostname = "aitne";
            clustered = true;
            clusterRole = "node";
        };

        callisto = helper.makeConsoleNixOS {
            hostname = "callisto";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
        mneme = helper.makeConsoleNixOS {
            hostname = "mneme";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "control";
        };
        iocaste = helper.makeConsoleNixOS {
            hostname = "iocaste";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "node";
        };
        kore = helper.makeConsoleNixOS {
            hostname = "kore";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "node";
        };
        eukelade = helper.makeConsoleNixOS {
            hostname = "eukelade";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "node";
        };
        harpalyke = helper.makeConsoleNixOS {
            hostname = "harpalyke";
            clustered = true;
            clusterTemplate = "m73";
            clusterRole = "node";
        };
      };

      colmena = {
        meta = {
          nixpkgs = pkgs;
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

        callisto = {
          deployment.targetHost = "callisto.local";
          deployment.targetUser = "bacon";
          nixosConfiguration = self.nixosConfigurations.callisto;
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

      kubenix = inputs.kubenix.packages.${pkgs.system}.default.override {
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
