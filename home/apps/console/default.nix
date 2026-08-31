{ pkgs, desktop, ... }: 
{
    imports = [
        ./git
        ./gpg
	./java
        ./neovim
    ];


    home.packages = with pkgs; [
        fastfetch
        fd
        file
        iperf3
        htop
        rclone
        ripgrep
    ];
}
