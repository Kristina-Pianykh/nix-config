{
  self,
  pkgs,
  user,
  system,
  ...
}: {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    pkgs.vim
  ];

  # Necessary for using flakes on this system.
  nix = {
    enable = false;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["root" user];
    };
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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  homebrew = {
    enable = true;
    brews = [
      # "bash"
      # "coreutils"
      # "go"
      # "ncurses"
      # "pkgconf"
      # "readline"
      # "xz"
      # "ca-certificates"
      # "gmp"
      # "mpdecimal"
      # "openssl@3"
      # "python@3.11"
      # "sqlite"
    ];
    casks = [
      "google-chrome"
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "postman"

      # managed by homebrew now
      "slack"
    ];
    onActivation.cleanup = "zap";
  };
}
