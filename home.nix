{
  config,
  pkgs,
  lib,
  inputs ? null,
  ...
}:
let
  nixvim =
    if (inputs ? nixvim) then
      inputs.nixvim
    else
      import (
        builtins.fetchGit {
          url = "https://github.com/nix-community/nixvim";
          ref = if config.settings.VERSION != "unstable" then "nixos-${config.settings.VERSION}" else "main";
        }
      );
in
{
  imports = [
    nixvim.homeModules.nixvim
    ./settings
    ./programs
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };

  home.username = lib.mkDefault config.settings.USER;
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  home.stateVersion = config.settings.VERSION;

  home.packages =
    with pkgs;
    [
      chromium
      fish
      gnupg
      maestral
      nixfmt
      pinentry-all
      qutebrowser
      tmux
    ]
    ++ [ config.programs.password-store.package ];

  home.sessionVariables = {
    inherit (config.settings)
      TZ
      ;
    MANPAGER = "nvim +Man!";
    TZDIR = "/usr/share/zoneinfo";
    EDITOR = "nvim";
    X = 5;
  };
}
