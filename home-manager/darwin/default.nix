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
  ];

  news.display = "silent";
  home = {
    packages = with pkgs; [
      fswatch

      # flink related
      podman
      gcloud
      kubectl
      protobuf
      nilaway
      pkgsUnstable.devenv
      gh
      teller
      temporal
      temporal-cli
    ];

    shellAliases = {
      f = "cd ~/flink";
      nix-rebuild = "darwin-rebuild switch --flake '${nixConfDir}#flink'";
      nix-conf = "cd ${nixConfDir} && nvim .";
    };
  };

  programs.zsh.initExtra = ''
    export GOPRIVATE=github.com/goflink/*

    export USE_GKE_GCLOUD_AUTH_PLUGIN=True

    homebrewPath="/opt/homebrew/bin"
    export PATH="$homebrewPath:$PATH"
  '';

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
