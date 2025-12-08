{
  cmp = {
    enable = true;
    #autoload = true;
    settings = {
      enableAutoSources = true;
      snippet.expand = ''
        function(args)
        			vim.snippet.expand(args.body)
        		end'';
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<Down>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
        "<Up>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
      };
      sources = [
        { name = "nvim_lsp"; }
        #{ name = "path"; }
        #{ name = "buffer"; }
      ];
      window =
        let
          opt = {
            border = [
              "┌"
              "─"
              "┐"
              "│"
              "┘"
              "─"
              "└"
              "│"
            ];
            winhighlight = "Normal:CmpNormal,FloatBorder:CmpSecondary";
          };
        in
        {
          completion = opt;
          documentation = opt;
        };
    };
  };
}
