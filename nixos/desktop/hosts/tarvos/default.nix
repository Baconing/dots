{ inputs, ... }:
{
    imports = [
        inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ];

    hardware.microsoft-surface.kernelVersion = "stable";
}
