{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  inputs,
  username,
  homeManagerStateVersion,
  ...
}: let
  # homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in {
  imports = [
    ./zsh.nix
    ./kitty.nix
    ./ghostty.nix
    ./git.nix
    ./ssh.nix
    ./ripgrep.nix
    ./yazi.nix
  ];

  home = {
    # inherit username homeDirectory;
    stateVersion = homeManagerStateVersion;
    packages = with pkgs; [
      lsd
      bat
      #joypixels
      rustup
      ripgrep
      fd # extends capabilities of rg
      fzf
      tree
      jq
      docker
      docker-compose
      ccls
      # python311Packages.compiledb
      prettierd
      astyle
      sops
      openssl
      netcat-gnu
      (bats.withLibraries (p: [p.bats-assert]))
      pkgsUnstable.hugo
      rclone
      codecrafters-cli
      yaml-language-server
      vscode-langservers-extracted
      vscode
      neovim
      htop

      # Terraform
      terraform-ls
      terraform
      tflint

      # Go
      pkgsUnstable.golangci-lint
      golangci-lint-langserver
      gotools
      gopls
      go

      # Python
      python311Packages.ipython
      poetry
      pyright
      ruff
      uv

      # Lua
      lua54Packages.luacheck
      lua-language-server
      stylua

      # Java
      vimPlugins.nvim-jdtls
      java-language-server
      jdt-language-server
      google-java-format
      maven
      jdk

      # Nix
      nixd
      alejandra
      nixfmt-rfc-style

      # JS
      nodejs_22
      deno # for markdown preview peek in neovim

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
