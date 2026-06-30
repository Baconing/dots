{ pkgs, ... }:
{
   environment = {
     systemPackages = with pkgs; [
         killall
         coreutils-full
         vim
         git
         sops
         colmena
	 python3
       ];
 
     variables = {
       EDITOR = "vim";
       SYSTEMD_EDITOR = "vim";
       VISUAL = "vim";
     };
   };
}
