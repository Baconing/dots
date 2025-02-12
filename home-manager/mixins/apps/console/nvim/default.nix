_:
{
  home = {
    programs.neovim = {
      enable = true;
    }
    home.file.".config/nvim/".source = ./lua; # todo, just use builtin configs.
  }
}
