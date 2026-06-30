{ pkgs, desktop, ... }: 
{
    imports = [
        ./git
        ./gpg
        ./neovim
    ];


    home.packages = with pkgs; [
        fastfetch
        fd
        file
        iperf3
        ripgrep
        htop
        rclone
    ];
}
