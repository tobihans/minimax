local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Tree-sitter ================================================================
now_if_args(function()
  Config.on_packchanged("nvim-treesitter", { "update" }, function() vim.cmd "TSUpdate" end, ":TSUpdate")

  -- Treesitter plugins
  add {
    "gh:nvim-treesitter/nvim-treesitter",
    "gh:nvim-treesitter/nvim-treesitter-context",
    "gh:nvim-treesitter/nvim-treesitter-textobjects",
  }

  require("treesitter-context").setup {
    enable = true,
    max_lines = 5,
    line_numbers = true,
    multiline_threshold = 10,
  }

  local is_lang_available = function(lang) return vim.list_contains(require("nvim-treesitter").get_available(), lang) end
  local isnt_installed = function(lang) return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0 end
  Config.new_autocmd("FileType", "", function(ev)
    local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
    if not lang then return end

    if isnt_installed(lang) and is_lang_available(lang) then
      require("nvim-treesitter").install(lang):await(function() vim.treesitter.start(ev.buf) end)
      return
    end

    if is_lang_available(lang) then vim.treesitter.start(ev.buf) end
  end, "Auto install & start tree-sitter")
end)

-- Language servers ===========================================================
-- FIXME: This seems not working for now. or maybe because tools are missing.
now_if_args(function()
  add { "gh:neovim/nvim-lspconfig" }

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

  vim.fn.sign_define {
    { name = "DiagnosticSignInfo", text = "󰋼", texthl = "DiagnosticInfo" },
    { name = "DiagnosticSignHint", text = "󰌵", texthl = "DiagnosticHint" },
    { name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticWarn" },
    { name = "DiagnosticSignError", text = "", texthl = "DiagnosticError" },
  }
end)

-- Formatting =================================================================
later(function()
  add { "gh:stevearc/conform.nvim" }

  local format_async = {} -- use async formatting when formatter is slow
  local function get_autoformat(bufnr)
    if vim.g.autoformat == nil then vim.g.autoformat = true end
    local autoformat = vim.b[bufnr].autoformat
    if autoformat == nil then autoformat = vim.g.autoformat end

    return autoformat
  end

  require("conform").setup {
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      injected = {
        options = {
          ignore_errors = true,
          lang_to_formatters = {},
        },
      },
    },
    formatters_by_ft = {
      astro = { "biome", "prettier", stop_after_first = true },
      css = { "biome", "prettier", stop_after_first = true },
      graphql = { "biome", "prettier", stop_after_first = true },
      htmldjango = { "djlint" },
      hurl = { "hurlfmt", "injected" },
      javascript = { "biome", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettier", stop_after_first = true },
      json = { "biome", "prettier", stop_after_first = true },
      lua = { "stylua" },
      markdown = { "prettierd", "prettier", "injected" },
      rust = { "rustfmt" },
      sh = { "shfmt" },
      sql = { "sqruff" },
      svelte = { "biome", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome", "prettier", stop_after_first = true },
      yaml = { "yamlfmt" },
    },
    format_on_save = function(bufnr)
      if format_async[vim.bo[bufnr].filetype] then return end
      local function on_format(err)
        if err and err:match "timeout$" then format_async[vim.bo[bufnr].filetype] = true end
      end

      ---@diagnostic disable-next-line: redundant-return-value
      if get_autoformat(bufnr) then return { timeout_ms = 500, lsp_fallback = true }, on_format end
    end,
    format_after_save = function(bufnr)
      if not format_async[vim.bo[bufnr].filetype] then return end

      if get_autoformat(bufnr) then return { lsp_fallback = true } end
    end,
  }
end)

-- Linting ====================================================================
later(function()
  add { "gh:mfussenegger/nvim-lint" }

  local lint = require "lint"

  lint.linters_by_ft = {
    eruby = { "erb_lint" },
    ["eruby.yaml"] = { "yamllint" },
    htmldjango = { "djlint" },
    lua = { "selene" },
    markdown = { "markdownlint" },
    proto = { "protolint", "buf_lint" },
    sh = { "shellcheck" },
    sql = { "sqruff" },
    yaml = { "yamllint" },
  }

  Config.new_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, "", function() lint.try_lint() end, "Lint")
end)

-- Snippets ===================================================================
later(function() add { "gh:rafamadriz/friendly-snippets" } end)

-- User Interface =============================================================
now(function()
  add {
    "gh:webhooked/kanso.nvim",
    "gh:AstroNvim/astroui",
    "gh:MunifTanjim/nui.nvim",
    "gh:folke/noice.nvim",
  }

  require("noice").setup(require "configs.noice")
  require("kanso").setup {
    background = {
      dark = "mist",
      light = "pearl",
    },
    overrides = function(_colors)
      return {
        WinSeparator = { link = "FloatBorder" },
      }
    end,
  }
  vim.cmd "color kanso" -- TODO: Replace w/ astroui setup
end)

-- Keymaps XP =================================================================
later(function()
  add { "gh:folke/which-key.nvim" }
  require("which-key").setup {
    preset = "modern",
  }
end)
