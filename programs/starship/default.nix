{

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
        threshold = 2;
      };
      cmd_duration.disabled = true;
      directory = {
        format = " [$path]($style)[$read_only]($read_only_style) ";
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_branch.format = " [$symbol$branch]($style) ";
    };
  };

}

