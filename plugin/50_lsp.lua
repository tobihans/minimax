local add = vim.pack.add

Config.now_if_args(function()
  add { "https://github.com/neovim/nvim-lspconfig" }

  vim.lsp.enable {
    "basedpyright",
    "cssls",
    "elixirls",
    "emmet_ls",
    "expert",
    "gopls",
    "html",
    "nushell",
    "pyrefly",
    "rust_analyzer",
    "tinymist",
    "vtsls",
  }
end)
