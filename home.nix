# vim: set ts=2 sw=2:

{ config, pkgs, ... }:

{
  home.username = "ben";
  home.homeDirectory = "/home/ben";

  home.stateVersion = "25.05";

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

  home.packages = [ ];

	# in the form "<conf file>".text = "x"
  home.file = { };

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
		EDITOR = "nvim";
		MANPAGER = "nvim +Man!";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
