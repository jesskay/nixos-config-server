{ config, pkgs, lib, ... }:
{
  sound.enable = true;

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    keyMode = "vi";
    clock24 = true;
    newSession = true;
    shortcut = "a";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ vim-nix ];
      };
    };
  };

  programs.bash.interactiveShellInit = ''
    eval "$(${pkgs.starship}/bin/starship init bash)"
  '';

  environment.systemPackages = with pkgs; [
    git
  ];
}
