{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  inputs,
  username,
  homeManagerStateVersion,
  sops-nix,
  ...
}:
let
  # homeDirectory = "/home/${username}";
  nullPackage = name: pkgs.writeShellScriptBin name "";
  shellAliases = {
    # nvim = "NVIM_APPNAME=neovim-config ${pkgs.neovim}/bin/nvim";
    hs = "home-manager switch";
    rm = "rm -f";
    ls = lib.mkForce "${pkgs.lsd}/bin/lsd -la";
    home = "cd ~/.config/home-manager && $EDITOR .";
    ipython = "ipython3";
    gl = "${./git_log_alias.sh}";
    gst = "git status";
  };
in
{
  imports = [
    (import ./zsh.nix {
      inherit
        shellAliases
        config
        pkgs
        lib
        ;
    })
    ./kitty.nix
    ./ghostty.nix
    ./git.nix
    ./ssh.nix
    ./ripgrep.nix
    ./yazi.nix
  ];
  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets.token = {
      sopsFile = ./../../secrets/openai_api.yaml;
    };
    # templates."example_secrets".content = ''
    #   token = "${config.sops.placeholder.token}"
    # '';
  };

  home = {
    # inherit username homeDirectory;
    stateVersion = homeManagerStateVersion;
    packages = with pkgs; [
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
      sops
      openssl
      netcat-gnu
      (bats.withLibraries (p: [ p.bats-assert ]))
      pkgsUnstable.hugo
      rclone
      codecrafters-cli
      vscode
      neovim
      htop
      podman
      obsidian
      pkg-config

      # Yaml
      yaml-language-server
      yq

      # Json
      prettierd
      vscode-langservers-extracted

      # C
      astyle

      # Terraform
      terraform-ls
      terraform
      tflint

      # Go
      pkgsUnstable.golangci-lint
      golangci-lint-langserver
      gotools
      nilaway
      gopls
      go
      gotestfmt

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

      (writeShellApplication {
        name = "codex";

        runtimeInputs = [ codex ];

        text = ''
          OPENAI_API_KEY="$(cat ${config.sops.secrets.token.path})"
          export OPENAI_API_KEY
          exec codex "$@"
        '';
      })
    ];

    sessionVariables = {
      EDITOR = "nvim";
      JAVA_HOME = pkgs.jdk;
    };
  };

  programs.bash.enable = true;

  #fonts.fontconfig.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      load_dotenv = true;
    };
  };

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;
}
