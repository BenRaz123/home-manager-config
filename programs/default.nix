{ pkgs, settings }:

{
  home-manager.enable = true;
  gh = import ./gh.nix;
  git = import ./git.nix;
  bash = import ./bash.nix { inherit settings; };
  nixvim = import ./nixvim { inherit pkgs settings; };
  tmux = import ./tmux.nix { inherit settings; };
}
