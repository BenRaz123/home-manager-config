{
  config,
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
let
  settings =
    (lib.evalModules {
      modules = [
        ./settings/options.nix
        ./settings/settings.nix
      ];
    }).config;
  nixvim = import (
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

  home.username = settings.USER;
  home.homeDirectory = "/home/${settings.USER}";

  home.stateVersion = settings.VERSION;

  programs.git = {
    enable = true;
    settings = {
      user.name = "BenRaz123";
      user.email = "ben.raz2008@gmail.com";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      gm = "mutt -F ~/.mutt/school.muttrc";
      Gm = "mutt -F ~/.mutt/personal.muttrc";
    };
    sessionVariables = {
      COLOR_START = ''\e[92m'';
      COLOR_END = ''\e[0m'';
      PS1 = ''[HM2 \u@\h $COLOR_START\w$COLOR_END]\$ '';
    };
    initExtra = ''
	. "$HOME/.nix-profile/etc/profile.d/nix.sh"
      export TZ=${settings.TZ}
      export TZDIR=/usr/share/zoneinfo
      set -o vi
    '';
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    clipboard.register = "unnamedplus";
  }
  // import (./nixvim) { inherit pkgs settings; };

  home.packages = with pkgs; [
    gh
    maestral
    nixfmt
    pass
    tmux
  ];

  # in the form "<conf file>".text = "x"
  home.file = {
    ".config/nix/nix.conf".text = "experimental-features = nix-command";
  };

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
    X =5;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
