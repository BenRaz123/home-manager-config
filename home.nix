{
  config,
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  osConfig ? { },
  inputs ? null,
  ...
}:
let
  settings =
    (lib.evalModules {
      specialArgs = { inherit pkgs; };
      modules = [
        ./settings/options.nix
        ./settings/settings.nix
      ];
    }).config;
  nixvim = if (inputs ? nixvim) then inputs.nixvim else import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = if settings.VERSION != "unstable" then "nixos-${settings.VERSION}" else "main";
    }
  );
in
{
  imports = [
    nixvim.homeModules.nixvim
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };
  programs = import ./programs { inherit pkgs settings; };

  home.username = lib.mkDefault settings.USER;
  home.homeDirectory = "/home/${settings.USER}";

  home.stateVersion = settings.VERSION;

  home.packages = with pkgs; [
    chromium
    fish
    gnupg
    maestral
    nixfmt
    pass
    pinentry-all
    qutebrowser
    tmux
  ];

  # in the form "<conf file>".text = "x"

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ben/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    MANPAGER = "nvim +Man!";
    TZ = settings.TZ;
    TZDIR = "/usr/share/zoneinfo";
    EDITOR = "nvim";
    X = 5;
  };

}
#// import ./wayland.nix { inherit pkgs osConfig; }
