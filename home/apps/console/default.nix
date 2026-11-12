{ pkgs, desktop, ... }: 
{
    imports = [
        ./git
        ./gpg
	./java
        ./neovim
    ];


    home.packages = with pkgs; [
        home-manager
        fastfetch
        fd
        file
        iperf3
        htop
        rclone
        ripgrep
    ];
}
