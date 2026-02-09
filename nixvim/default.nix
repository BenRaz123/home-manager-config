{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  settings ? {},
  ...
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
    tabstop = settings.TAB_WIDTH;
    shiftwidth = settings.TAB_WIDTH;
    number = true;
    relativenumber = true;
    signcolumn = "yes";
  };
  globals = {
    mapleader = " ";
  };
  extraPlugins = (import ./extra_plugins.nix) { inherit pkgs lib; } ;
  plugins = {
    lsp = import ./lsp.nix;
  }
  // (import ./plugins.nix { inherit settings; });
  autoCmd = (import ./autocmds.nix) { inherit lib; };
  keymaps = (import ./keymaps.nix) { inherit lib; };
  extraConfigLua = builtins.readFile ./extraConfig.lua;
}
