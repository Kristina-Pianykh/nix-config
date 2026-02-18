{
  self,
  pkgs,
  user,
  system,
  ...
}:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  # Necessary for using flakes on this system.
  nix = {
    enable = false;
  };

  users = {
    users.${user} = {
      home = "/Users/${user}";
      name = "${user}";
    };
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.keyboard.swapLeftCtrlAndFn = true;
  system.defaults = {
    NSGlobalDomain = {
      AppleShowScrollBars = "Always";
      NSAutomaticWindowAnimationsEnabled = false;
      _HIHideMenuBar = true;
      "com.apple.swipescrolldirection" = false;
    };
    WindowManager = {
      HideDesktop = true;
      StandardHideDesktopIcons = true;
    };
    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = true;
    };
    dock = {
      autohide = true;
      expose-animation-duration = null;
      launchanim = false;
      magnification = false;
      show-recents = false;
      persistent-apps = [
        {
          app = "${pkgs.obsidian}/Applications/Obsidian.app";
        }
      ];
    };
    finder = {
      CreateDesktop = false;
      QuitMenuItem = true;
      ShowPathbar = true;
    };
  };

  # TODO: NIXIFY!!!
  # https://github.com/amarsyla/hidutil-key-remapping-generator
  # fucking macos escapes quotes in the command line args
  # config file ~/Library/LaunchAgents/com.local.KeyRemapping.plist
  # is managed manually now
  # https://github.com/nix-darwin/nix-darwin/issues/1566
  # launchd = {
  #   user.agents.keyRemap = {
  #     serviceConfig = {
  #       Label = "com.local.KeyRemapping";
  #       ProgramArguments = [
  #         "/usr/bin/hidutil"
  #         "property"
  #         "--set"
  #         "\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\": 0xFF00000003, \"HIDKeyboardModifierMappingDst\": 0x7000000E0}]}"
  #       ];
  #       RunAtLoad = true;
  #     };
  #   };
  # };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = "kristina.pianykh@goflink.com";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  homebrew = {
    enable = true;
    casks = [
      "google-chrome"
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "postman"
      "amneziavpn"
      "brave-browser"
      "zoom"
      "firefox"

      # managed by homebrew now
      "slack"
    ];
    onActivation.cleanup = "zap";
  };
}
