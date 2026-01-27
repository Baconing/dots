{
  config,
  hostname,
  clustered,
  inputs,
  lib,
  modulesPath,
  outputs,
  pkgs,
  platform,
  stateVersion,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    (modulesPath + "/installer/scan/not-detected.nix")
    ./user.nix
  ] ++ lib.optional (builtins.pathExists ./${hostname}) ./${hostname} ++ lib.optional (clustered) ./cluster;

  boot = {
    consoleLogLevel = lib.mkDefault 0;
    initrd.verbose = false;
    kernelModules = [ "vhost_vsock" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

    # Don't install bootloader on ISO images.
    loader = {
      systemd-boot.enable = false;

      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        useOSProber = true;
        efiSupport = true;
        device = "nodev";
      };

      timeout = 10;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  # todo move?
  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
  };

  # todo same as above
  environment = {
    defaultPackages = with pkgs; lib.mkForce [
	      killall
        coreutils-full
        vim
        git
      ];

    systemPackages = with pkgs; [
        sops
      ];

    variables = {
      EDITOR = "vim";
      SYSTEMD_EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  sops.age = {
    keyFile = "/var/lib/private/sops/age/keys.txt";
    generateKey = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "flakes nix-command";
        # Disable global registry
        flake-registry = "";
        trusted-users = [
          "root"
          "bacon"
        ];
        warn-dirty = false;
      };
      # Disable channels
      channel.enable = false;
      # Make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };

  nixpkgs.hostPlatform = lib.mkDefault "${platform}";

  system = {
    inherit stateVersion;
  };
}