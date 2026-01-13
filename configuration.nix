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
