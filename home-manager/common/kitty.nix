{
  pkgs,
  config,
  ...
}:
{
  programs.kitty = {
    enable = true;
    # package =
    #   pkgs.writeScriptBin "null" "";

    font = {
      name = "FiraCode Nerd Font";
      size = 14;
    };
    themeFile = "rose-pine";
    settings = {
      enabled_layouts = "tall,vertical,stack";
      shell = "${config.programs.zsh.package}/bin/zsh";
      window_padding_width = 10;
      confirm_os_window_close = 0;
    };
  };
}
