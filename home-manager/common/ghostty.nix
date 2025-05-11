{
  pkgs,
  config,
  ...
}: {
  programs.ghostty = {
    enable = true;
    package =
      pkgs.writeScriptBin "null" "";
    enableZshIntegration = true;
    # installVimSyntax = true;
    settings = {
      theme = "dark:rose-pine";
      fullscreen = "true";
      font-family = "FiraCode Nerd Font";
      font-size = 14;
      confirm-close-surface = "false";
      keybind = [
        "ctrl+tab=next_tab"
        "ctrl+tab+shift=previous_tab"
      ];
    };
  };
}
