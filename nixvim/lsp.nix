{
  enable = true;
  servers = {
    phpactor.enable = true;
    html.enable = true;
    ts_ls.enable = true;
    clangd.enable =true;
    rust_analyzer = {
      enable = true;
      installCargo = true;
      installRustc = true;
    };
    nil_ls = {
      enable = true;
      settings.config.formatting.command = ["nixfmt"];
    };
    pyright.enable = true;
    lua_ls.enable = true;
  };
}
