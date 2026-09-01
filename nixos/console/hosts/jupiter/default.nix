_:
{
    imports = [
        ./disks.nix
        ./network
    ];

    services.openssh.ports = [ 2222 ];
}