{pkgs, ...}: let
  # username = "kristina.pianykh@goflink.com";
  # the use of homeDirectory https://github.com/nix-community/home-manager/issues/6036#issuecomment-2466986456
  # homeDirectory = "/Users/${user}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin];
in {
  _module.args = {
    sshWorkHostAlias = "work";
  };

  imports = [
    ./zsh.nix
    ./launchd.nix
    ./kitty.nix
    ./ghostty.nix
    ./git.nix
    ./ssh.nix
    ./dotfiles/ideavimrc.nix
    ./ripgrep.nix
    ./yazi.nix
  ];

  # nixpkgs.overlays = [
  #   (final: _: {
  #     unstable = import inputs.nixpkgs-unstable {
  #       system = final.system;
  #       config.allowUnfree = true;
  #     };
  #     stable = import inputs.nixpkgs-stable {
  #       system = final.system;
  #       config.allowUnfree = true;
  #     };
  #   })
  #   inputs.nixgl.overlay
  # ];

  news.display = "silent";
  home = {
    stateVersion = "23.11";
    # test = {a = 1; b = 2;};
    # sum = test.a + test.b;
    # sum = with test; a + b;
    packages = with pkgs; [
      lsd
      bat
      #joypixels
      rustup
      ripgrep
      poetry
      uv
      tree
      jdk
      fzf
      jq
      docker
      docker-compose
      tflint
      go
      gopls
      gotools
      maven
      fd # extends capabilities of rg
      pyright
      lua-language-server
      lua54Packages.luacheck
      java-language-server
      jdt-language-server
      vimPlugins.nvim-jdtls
      ccls
      # python311Packages.compiledb
      google-java-format
      prettierd
      stylua
      astyle
      ruff
      alejandra
      # nodejs_22
      terraform-ls
      terraform
      vscode
      sops
      python311Packages.ipython
      openssl
      netcat-gnu
      python311Packages.ipython
      (bats.withLibraries (p: [p.bats-assert]))
      hugo
      rclone
      codecrafters-cli
      neovim
      podman
      # google-cloud-sdk
      gcloud
      kubectl
      htop
      fswatch
      # deno # for markdown preview peek in neovim
      nixd
      yaml-language-server

      # flink related
      protobuf
      golangci-lint
      golangci-lint-langserver
      nilaway

      # (writeShellApplication {
      #   name = "show-nixos-org";
      #
      #   runtimeInputs = [curl w3m];
      #
      #   text = ''
      #     curl -s 'https://nixos.org' | w3m -dump -T text/html
      #   '';
      # })
    ];

    sessionVariables = {
      EDITOR = "nvim";
      JAVA_HOME = pkgs.jdk;
    };

    shellAliases = {
      # nvim = "NVIM_APPNAME=neovim-config ${pkgs.neovim}/bin/nvim";
      f = "cd ~/flink";
      hs = "home-manager switch";
      ls = "lsd -la";
      lsd = "lsd -la";
      rm = "rm -f";
      home = "cd ~/.config/home-manager && $EDITOR .";
      ipython = "ipython3";
      gl = "${./git_log_alias.sh}";
      gst = "git status";
    };
  };

  #fonts.fontconfig.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      package.disabled = true;
      # gcloud.detect_env_vars = ["CLOUDSDK_CONFIG" "CLOUDSDK_ACTIVE_CONFIG_NAME" "CLOUDSDK_PROFILE"];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;
}
