{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.file."watcher.sh" = {
    text = ''
      #!/usr/bin/env sh

      WATCHED_DIR=$HOME/Documents/KeePass
      WATCHED_FILE=$WATCHED_DIR/Database.kdbx
      REMOTE=drive:KeeShit/ # TODO

      echo "Watching $WATCHED_FILE for changes..."

      fswatch --event Updated --event MovedTo "$WATCHED_DIR" | while read; do
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Change detected, syncing..."
        rclone copy "$WATCHED_FILE" "$REMOTE"
      done
    '';
    executable = true;
  };

  launchd = {
    enable = true;
    agents."com.local.KeyRemapping" = {
      enable = true;
      config = {
        Label = "com.local.KeyRemapping";
        ProgramArguments = [
          "/usr/bin/hidutil"
          "property"
          "--set"
          ''{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc": 0xFF00000003,"HIDKeyboardModifierMappingDst": 0x7000000E0},{"HIDKeyboardModifierMappingSrc": 0x700000064,"HIDKeyboardModifierMappingDst": 0x700000035}]}''
        ];
        RunAtLoad = true;
      };
    };
    agents."dev.kristina.watcher.plist" = {
      enable = false;
      config = {
        Program = "${config.home.homeDirectory}/watcher.sh";
        Label = "dev.kristina.watcher.plist";
        RunAtLoad = true;
        EnvironmentVariables = {
          PATH = "${lib.makeBinPath [
            pkgs.bash
            pkgs.rclone
            pkgs.coreutils
            pkgs.fswatch
          ]}";
        };
        StandardOutPath = "/tmp/watcher.out.log";
        StandardErrorPath = "/tmp/watcher.err.log";
        KeepAlive = true;
      };
    };
  };
}
