{
  config,
  hostname,
  clustered,
  desktop,
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
    ./user.nix
    ./packages.nix
  ] ++ lib.optional (builtins.pathExists ./hosts/${hostname}) ./hosts/${hostname} ++ lib.optional (desktop) ./desktop ++ lib.optional (clustered) ./cluster;

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
    hostPlatform = lib.mkDefault "${platform}";
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

  hardware.enableRedistributableFirmware = true;

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

  system = {
    inherit stateVersion;
  };
}
