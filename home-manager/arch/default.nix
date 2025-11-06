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
  homeDirectory = "/home/${username}";
  nixConfDir = "${config.xdg.configHome}/nix-config";
  nullPackage = name: pkgs.writeShellScriptBin name "";
in
{
  imports = [
    ../common/default.nix
    ./systemd.nix
  ];

  home = {
    inherit username homeDirectory;
    packages = with pkgs; [
      inotify-tools # archie
      calibre
    ];
    shellAliases = {
      nix-rebuild = "home-manager switch --flake '${nixConfDir}#krispian'";
      nix-conf = "cd ${nixConfDir} && nvim .";
    };
  };

  programs.kitty = {
    package = pkgs.writeScriptBin "null" "";
    keybindings = {
      "Alt+enter" = "new_window_with_cwd";
      "Alt+d" = "close_window";
      "Alt+j" = "next_window";
      "Alt+k" = "previous_window";
      "Alt+s" = "next_layout";
    };
  };

  programs.ghostty.settings.keybind = [
    "alt+enter=new_split:auto"
    "alt+d=close_surface"
    "alt+k=goto_split:top"
    "alt+j=goto_split:bottom"
    "alt+h=goto_split:left"
    "alt+l=goto_split:right"
    "alt+t=new_tab"
  ];

  programs.git = {
    userEmail = "kristinavrnrus@gmail.com";
    signing = {
      key = "C66C7DFC66E169F1";
      gpgPath = "${pkgs.gnupg}/bin/gpg";
      # gpgPath = "/usr/bin/gpg";
      signByDefault = true;
    };
  };

  programs.ssh.matchBlocks = {
    # work = {
    #   host = "work";
    #   hostname = "github.com";
    #   identitiesOnly = true;
    #   identityFile = "${config.home.homeDirectory}/.ssh/work";
    #   extraOptions = {
    #     AddKeysToAgent = "yes";
    #     UseKeychain = "yes";
    #   };
    # };
    server = {
      host = "disco";
      hostname = "192.168.2.217";
      user = "discoman";
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/disco";
    };
    priv = {
      host = "priv";
      hostname = "github.com";
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/private";
      extraOptions = {
        AddKeysToAgent = "yes";
        # UseKeychain = "yes";
      };
    };
    gitlab = {
      host = "gitlab";
      hostname = "cfgit.ddnss.de";
      identitiesOnly = true;
      identityFile = "${config.home.homeDirectory}/.ssh/private";
      extraOptions = {
        AddKeysToAgent = "yes";
        # UseKeychain = "yes";
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        close = [ "<Alt>q" ];
        switch-to-workspace-1 = [ "<Alt>1" ];
        switch-to-workspace-2 = [ "<Alt>2" ];
        switch-to-workspace-3 = [ "<Alt>3" ];
        switch-to-workspace-4 = [ "<Alt>4" ];
        switch-to-workspace-5 = [ "<Alt>5" ];
        switch-to-workspace-6 = [ "<Alt>6" ];
        switch-to-workspace-7 = [ "<Alt>7" ];
        switch-to-workspace-8 = [ "<Alt>8" ];
      };

      "org/gnome/shell" = {
        enabled-extensions = [
          "color-picker@tuberry"
          "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        ];
      };
      "org/gnome/shell/extensions/auto-move-windows" = {
        application-list = [
          "brave-browser.desktop:1"
          "kitty.desktop:2"
          "org.telegram.desktop.desktop:3"
          "md.obsidian.Obsidian:6"
        ];
      };
    };
  };

  xdg.enable = true;
  xdg.configFile."easyeffects/output/advanced-auto-gain.json".source =
    let
      AAGainFile = pkgs.fetchurl {
        url = "https://github.com/JackHack96/EasyEffects-Presets/raw/834bc5007b976250190cd71937c8c22f182d2415/Advanced%20Auto%20Gain.json";
        hash = "sha256-AXzy04ORMeg39H7ojkRtuumT0HU0nKLkU1SKmmD9zzQ=";
      };
      AAGain = builtins.fromJSON (builtins.readFile AAGainFile);
      dolbyAtmos = pkgs.fetchurl {
        url = "https://github.com/JackHack96/EasyEffects-Presets/raw/5804c736be654de36c2fc052bff10260c1ac33c5/irs/Dolby%20ATMOS%20((128K%20MP3))%201.Default.irs";
        hash = "sha256-9Ft1HZLFTBiGRfh/wJiGZ9WstMtvdtX+u3lVY3JCVAM=";
      };
      extendedAAGain = AAGain // {
        output =
          AAGain.output
          // {
            "convolver" = {
              "autogain" = true;
              "bypass" = false;
              "input-gain" = 0.0;
              "ir-width" = 100;
              "kernel-path" = "${dolbyAtmos}";
              "output-gain" = 0.0;
            };
          }
          // {
            plugins_order =
              (lib.sublist 0 3 AAGain.output.plugins_order)
              ++ [ "convolver" ]
              ++ (lib.sublist 3 100 AAGain.output.plugins_order);
          };
      };
      source = pkgs.writeText "extendedAAGain" (builtins.toJSON extendedAAGain);
    in
    "${source}";
}
