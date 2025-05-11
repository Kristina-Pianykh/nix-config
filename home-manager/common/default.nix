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

  # everything down below belongs to archie
  # xdg.enable = true;
  # xdg.configFile."easyeffects/output/advanced-auto-gain.json".source = let
  #   AAGainFile = pkgs.fetchurl {
  #     url = "https://github.com/JackHack96/EasyEffects-Presets/raw/834bc5007b976250190cd71937c8c22f182d2415/Advanced%20Auto%20Gain.json";
  #     hash = "sha256-AXzy04ORMeg39H7ojkRtuumT0HU0nKLkU1SKmmD9zzQ=";
  #   };
  #   AAGain = builtins.fromJSON (builtins.readFile AAGainFile);
  #   dolbyAtmos = pkgs.fetchurl {
  #     url = "https://github.com/JackHack96/EasyEffects-Presets/raw/5804c736be654de36c2fc052bff10260c1ac33c5/irs/Dolby%20ATMOS%20((128K%20MP3))%201.Default.irs";
  #     hash = "sha256-9Ft1HZLFTBiGRfh/wJiGZ9WstMtvdtX+u3lVY3JCVAM=";
  #   };
  #   extendedAAGain =
  #     AAGain
  #     // {
  #       output =
  #         AAGain.output
  #         // {
  #           "convolver" = {
  #             "autogain" = true;
  #             "bypass" = false;
  #             "input-gain" = 0.0;
  #             "ir-width" = 100;
  #             "kernel-path" = "${dolbyAtmos}";
  #             "output-gain" = 0.0;
  #           };
  #         }
  #         // {
  #           plugins_order = (lib.sublist 0 3 AAGain.output.plugins_order) ++ ["convolver"] ++ (lib.sublist 3 100 AAGain.output.plugins_order);
  #         };
  #     };
  #   source = pkgs.writeText "extendedAAGain" (builtins.toJSON extendedAAGain);
  # in "${source}";
}
