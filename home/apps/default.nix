{ desktop, lib, ... }: 
{
    imports = [
        ./console
    ] ++ lib.optional (desktop) ./desktop;
}
