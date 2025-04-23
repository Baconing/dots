{ username, pkgs, ... }:
{
   environment.systemPackages = with pkgs; [ networkmanager-openvpn ];
   networking.networkmanager.enable = true;
   users.users.${username}.extraGroups = ["networkmanager"];
}
