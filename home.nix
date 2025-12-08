{ config, pkgs, ... }:

let
  VERSION = "25.05";
  USER = "ben";
  TAB_WIDTH = 4;
  nixvim = import (
    builtins.fetchGit {
      url = "https://github.com/nix-community/nixvim";
      ref = if VERSION != "unstable" then "nixos-${VERSION}" else "main";
    }
  );
in
{
  imports = [
    nixvim.homeModules.nixvim
  ];

  home.username = USER;
  home.homeDirectory = "/home/${USER}";

  home.stateVersion = VERSION;

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
    initExtra = ''set -o vi'';
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    clipboard.register = "unnamedplus";
  }
  // import (./nixvim) { inherit pkgs TAB_WIDTH; };

  home.packages = with pkgs; [
    nixfmt-rfc-style
  ];

  # in the form "<conf file>".text = "x"
  home.file = {
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
