{ lib }:

with lib;
[
  (mkAutoCmdCb "BufWritePost" "*" ''
    local client = vim.lsp.get_clients({bufnr=args.buf})[1]
    if not client then
      return
    end
    if client.supports_method(client, "textDocument/formatting") then
      vim.lsp.buf.format()
    end
  '')
  (mkAutoCmdCb [ "BufRead" "BufNewFile" ] "*.lua" ''
    vim.keymap.set("ia", "!=", "~=", {buffer=args.buf})
    vim.keymap.set("ia", ">f", "function", {buffer=args.buf})
  '')
  (mkAutoCmd "BufRead" "*.muttrc" "set ft=muttrc")
  (mkAutoCmd "FileType" "mail" "WrapWidth 80 | set spell tw=0")
  (mkAutoCmd "BufEnter" "*nix" "set tabstop=2 shiftwidth=2 expandtab")
]
