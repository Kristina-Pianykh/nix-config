{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  inputs,
  username,
  homeManagerStateVersion,
  ...
}:
let
  sshWorkHostAlias = "work";
  nixConfDir = "/private/etc/nix-darwin";
  nullPackage = name: pkgs.writeShellScriptBin name "";
  gcloud = pkgs.google-cloud-sdk.withExtraComponents [
    pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin
  ];
in
{
  imports = [
    ../common/default.nix
    ./launchd.nix
    ./aerospace.nix
  ];

  news.display = "silent";
  home = {
    packages = with pkgs; [
      fswatch

      # flink related
      # podman
      gcloud
      kubectl
      pkgsUnstable.kubernetes-helm
      protobuf
      protoc-gen-go
      protoc-gen-go-grpc
      nilaway
      pkgsUnstable.devenv
      devbox
      gh
      teller
      temporal
      temporal-cli
      ngrok
      presenterm
      k6
      pkgsUnstable.gemini-cli
      kustomize
      kind
      aerospace
    ];

    shellAliases = {
      f = "cd ~/flink";
      nix-rebuild = "sudo darwin-rebuild switch --flake '${nixConfDir}#flink'";
      nix-conf = "cd ${nixConfDir} && nvim .";
    };
  };

  # programs.zsh.initExtra = ''
  programs.zsh.initContent = lib.mkMerge [
    (lib.mkBefore ''
      export GOPRIVATE=github.com/goflink/*

      export USE_GKE_GCLOUD_AUTH_PLUGIN=True

      homebrewPath="/opt/homebrew/bin"
      export PATH="$homebrewPath:$PATH"
      export GOOGLE_CLOUD_PROJECT=flink-gemini-sandbox
    '')
  ];

  programs.kitty = {
    keybindings = {
      "super+enter" = "new_window_with_cwd";
      "super+d" = "close_window";
      "super+j" = "next_window";
      "super+k" = "previous_window";
      "super+s" = "next_layout";
    };
  };

  programs.ghostty.settings.keybind = [
    "super+enter=new_split:auto"
    "super+d=close_surface"
    "super+k=goto_split:top"
    "super+j=goto_split:bottom"
    "super+h=goto_split:left"
    "super+l=goto_split:right"
    "super+t=new_tab"
    "ctrl+tab=next_tab"
  ];

  programs.git = {
    userEmail = "kristina.pianykh@goflink.com";
    extraConfig.url = {
      "git@github.com:goflink" = {
        insteadOf = "https://github.com/goflink";
      };
    };
    extraConfig.url = {
      "git@${sshWorkHostAlias}:goflink" = {
        insteadOf = "https://github.com/goflink";
      };
    };
    # extraConfig.url = {
    #   "git@github.com" = {
    #     insteadOf = "https://github.com";
    #   };
    # };
  };

  programs.starship = {
    settings = {
      gcloud.format = "on [$symbol$project]($style) ";
      gcloud.project_aliases = {
        "flink-core-shared" = "shared";
        "flink-core-staging" = "staging";
      };
      custom.kubectl = {
        when = "kubectl config current-context";
        command = "kubectl config current-context | awk -F'-' '{print $NF}'";
        format = "on [$symbol$output]($style) ";
        style = "bold green";
        # symbol = "☸️ ";
        symbol = "⎈ ";
      };
    };
  };

  programs.ssh.matchBlocks = {
    "github.com" = {
      host = "github.com";
      hostname = "github.com";
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/${sshWorkHostAlias}";
      extraOptions = {
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
      };
    };
    "${sshWorkHostAlias}" = {
      host = sshWorkHostAlias;
      hostname = "github.com";
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/${sshWorkHostAlias}";
      extraOptions = {
        AddKeysToAgent = "yes";
        UseKeychain = "yes";
      };
    };
  };
}
