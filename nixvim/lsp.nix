{
  enable = true;
  servers = {
    nil_ls = {
      enable = true;
      settings.config.formatting.command = "nixfmt";
    };
    pyright.enable = true;
    lua_ls.enable = true;
  };
}
