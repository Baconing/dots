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

  	 p7zip
  	 unzip
  	 zip
  	 unrar
  	 gnutar
  	 gzip
  	 bzip2
  	 lz4
  	 zstd
       ];
 
     variables = {
       EDITOR = "vim";
       SYSTEMD_EDITOR = "vim";
       VISUAL = "vim";
     };
   };
}
