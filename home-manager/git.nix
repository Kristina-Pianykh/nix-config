{
  config,
  pkgs,
  sshWorkHostAlias,
  ...
}: {
  home.packages = with pkgs; [gnupg];

  programs.git = {
    enable = true;
    userName = "Kristina Pianykh";
    userEmail = "kristina.pianykh@goflink.com";
    # signing = {
    #   key = "C66C7DFC66E169F1";
    #   signer = "${pkgs.gnupg}/bin/gpg";
    #   # gpgPath = "/usr/bin/gpg";
    #   signByDefault = true;
    # };
    diff-so-fancy.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core.editor = "nvim";
      status.submodulesummary = "1";
      url = {
        "git@${sshWorkHostAlias}:goflink" = {
          # TODO: reference from ssh.nix
          insteadOf = "https://github.com/goflink";
        };
      };
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
