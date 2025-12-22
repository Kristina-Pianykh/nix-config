{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ripgrep = {
    enable = true;
    # package = pkgs.ripgrep;
    arguments = [
      "--no-ignore"
      "--hidden"
      "-g"
      "!**/.git/**"
      "-g"
      "!**/.venv"
      "-g"
      "!**/dist"
      "-g"
      "!**/build"
      "-g"
      "!**/target"
      "-g"
      "!**/*cache*"
      "-g"
      "!**/__pycache__"
      "-g"
      "!**/*.pyc"
      "-g"
      "!**/node_modules"
      "-g"
      "!**/package-lock.json"
      "-g"
      "!**/go.mod"
      "--unrestricted"
      "--smart-case"
    ];
  };
}
