{
  pkgs ? import <nixpkgs> { },
  TAB_WIDTH,
}:

let
  lib = {
    mkAutoCmd = event: pattern: command: { inherit event pattern command; };
    mkAutoCmdCb = event: pattern: cb: {
      inherit event pattern;
      callback = {
        __raw = "function (args)\n${cb}\nend";
      };
    };
    mkKeyMap = key: action: mode: { inherit key action mode; };
  };
in
{
  clipboard.register = "unnamedplus";
  opts = {
    tabstop = TAB_WIDTH;
    shiftwidth = TAB_WIDTH;
    number = true;
    relativenumber = true;
	signcolumn = "yes";
  };
  globals = {
	mapleader = " ";
  };
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "gitsigns";
      src = builtins.fetchGit {
        url = "https://github.com/lewis6991/gitsigns.nvim";
      };
    })
  ];
  plugins = {
    lsp = import ./lsp.nix;
  }
  // (import ./plugins.nix);
  autoCmd = (import ./autocmds.nix) { inherit lib; };
  keymaps = (import ./keymaps.nix) { inherit lib; };
  extraConfigLua = builtins.readFile ./extraConfig.lua;
}
