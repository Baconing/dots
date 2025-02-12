{
  config,
  hostname,
  isISO,
  isDesktop,
  inputs,
  lib,
  modulesPath,
  outputs,
  pkgs,
  platform,
  stateVersion,
  username,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    (modulesPath + "/installer/scan/not-detected.nix")
    ./${hostname}
    ./mixins
  ];

  boot = {
    consoleLogLevel = lib.mkDefault 0;
    initrd.verbose = false;
    kernelModules = [ "vhost_vsock" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

    # Don't install bootloader on ISO images.
    loader = lib.mkIf (!isISO) {
      systemd-boot.enable = false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
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
  environment = {
    defaultPackages =
      with pkgs;
      lib.mkForce [
        coreutils-full
        vim
      ];

    systemPackages = with pkgs;
      [
          git
      ] ++ lib.optionals (!isISO) [
        sops
      ];

    variables = {
      EDITOR = "vim";
      SYSTEMD_EDITOR = "vim";
      VISUAL = "vim";
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
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
        trusted-users = [
          "root"
          "${username}"
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

  sops = lib.mkIf (!isISO) {
    age = {
      keyFile = "/var/lib/private/sops/age/keys.txt";
      generateKey = false;
    };
    secrets = {
      userPassword = {
          sopsFile = ../secrets/users/${username}.yaml;
          neededForUsers = true;
      };
      luksEncryptionPassword = {
          sopsFile = ../secrets/${hostname}.yaml;
      };
    };
  };

  system = {
    activationScripts = {
      nixos-needsreboot = lib.mkIf (!isISO) {
        supportsDryActivation = true;
        text = "${lib.getExe inputs.nixos-needsreboot.packages.${pkgs.system}.default} \"$systemConfig\" || true";
      };
    };
    nixos.label = lib.mkIf (!isISO) "-";
    inherit stateVersion;
  };
}
