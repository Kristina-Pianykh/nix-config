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
      # keybind = [
      #   "alt+enter=new_split:auto"
      #   "alt+d=close_surface"
      #   "alt+k=goto_split:top"
      #   "alt+j=goto_split:bottom"
      #   "alt+h=goto_split:left"
      #   "alt+l=goto_split:right"
      #   "alt+t=new_tab"
      #   "ctrl+tab=next_tab"
      # ];
    };
  };
}
