{
  config,
  pkgs,
  ...
}:
{
  # use for darwin
  # home.packages = with pkgs; [gnupg];

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };
  programs.git = {
    enable = true;
    # userEmail = "kristinavrnrus@gmail.com";
    # signing = {
    #   key = "C66C7DFC66E169F1";
    #   gpgPath = "/usr/bin/gpg";
    #   signByDefault = true;
    # };
    settings = {
      user.name = "Kristina Pianykh";
      init = {
        defaultBranch = "main";
      };
      core.editor = "nvim";
      status.submodulesummary = "1";
    };
    # includes = [
    #   {
    #     condition = "gitdir:${config.home.homeDirectory}/Work/";
    #     contents = {
    #       user = {
    #         name = "Kristina Pianykh";
    #         email = "kristina.pianykh@diconium.com";
    #         signingKey = "3A09BEC8E7DCA833";
    #       };
    #       commit = {
    #         gpgSign = true;
    #       };
    #     };
    #   }
    # ];
  };
}
