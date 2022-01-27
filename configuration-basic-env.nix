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

  programs.starship = {
    enable = true;
    settings = {
      username = {
        format = "[$user]($style)";
        show_always = true;
      };
      hostname = {
        format = "@[$hostname]($style) ";
        ssh_only = true;
      };
      shlvl = {
        disabled = false;
        symbol = " 🐚";
        threshold = 1;
      };
      cmd_duration.disabled = true;
      directory = {
        format = " [$path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_branch.format = " [$symbol$branch]($style) ";
      character.error_symbol = "💥";
    };
  };

  environment.shellAliases = {
    cat = "bat";
  };

  environment.systemPackages = with pkgs; [
    git
    ripgrep
    bat
  ];
}
