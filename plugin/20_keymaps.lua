local pickers = require "pickers"
local misc = require "misc"

-- General mappings ===========================================================
local map = vim.keymap.set
local nmap = function(lhs, rhs, desc, opts) map("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local xmap = function(lhs, rhs, desc, opts) map("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local vmap = function(lhs, rhs, desc, opts) map("v", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end

nmap("0", "^", "First non-blank character")

nmap("j", "v:count == 0 ? 'gj' : 'j'", "Move cursor down", { expr = true, silent = true })
xmap("j", "v:count == 0 ? 'gj' : 'j'", "Move cursor down", { expr = true, silent = true })
nmap("k", "v:count == 0 ? 'gk' : 'k'", "Move cursor up", { expr = true, silent = true })
xmap("k", "v:count == 0 ? 'gk' : 'k'", "Move cursor up", { expr = true, silent = true })
vmap("<S-Tab>", "<gv", "Unindent line")
vmap("<Tab>", ">gv", "Indent line")

nmap("|", "<Cmd>vsplit<CR>", "Vertical Split")
nmap("\\", "<Cmd>split<CR>", "Horizontal Split")

nmap("gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", "Add Comment Below")
nmap("gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", "Add Comment Above")

-- Neovim Default LSP Mappings
nmap("gra", function() vim.lsp.buf.code_action() end, "vim.lsp.buf.code_action()")
xmap("gra", function() vim.lsp.buf.code_action() end, "vim.lsp.buf.code_action()")
nmap("grn", function() vim.lsp.buf.rename() end, "vim.lsp.buf.rename()")
nmap("grr", function() vim.lsp.buf.references() end, "vim.lsp.buf.references()")
nmap("gri", function() vim.lsp.buf.implementation() end, "vim.lsp.buf.implementation()")
nmap("gO", function() vim.lsp.buf.document_symbol() end, "vim.lsp.buf.document_symbol()")
nmap("gl", function() vim.diagnostic.open_float() end, "Hover diagnostics")

-- Diagnostics

-- Tabs
-- FIXME: Remove and focus on mini.basics
-- nmap("]t", function() vim.cmd.tabnext() end, "Next tab")
-- nmap("[t", function() vim.cmd.tabprevious() end, "Previous tab")

-- List management
-- nmap("]q", vim.cmd.cnext, "Next quickfix")
-- nmap("[q", vim.cmd.cprev, "Previous quickfix")
-- nmap("]Q", vim.cmd.clast, "End quickfix")
-- nmap("[Q", vim.cmd.cfirst, "Beginning quickfix")
-- nmap("]l", vim.cmd.lnext, "Next loclist")
-- nmap("[l", vim.cmd.lprev, "Previous loclist")
-- nmap("]L", vim.cmd.llast, "End loclist")
-- nmap("[L", vim.cmd.lfirst, "Beginning loclist")

-- Leader mappings ============================================================
Config.leader_groups = {
  { "<Leader>s", group = "󰛔 Search/Replace" },
}
local nmap_leader = function(suffix, rhs, desc, opts) nmap("<Leader>" .. suffix, rhs, desc, opts) end
local xmap_leader = function(suffix, rhs, desc, opts) xmap("<Leader>" .. suffix, rhs, desc, opts) end

nmap_leader("q", "<Cmd>confirm q<CR>", "Quit Window")
nmap_leader("Q", "<Cmd>confirm qall<CR>", "Exit Neovim")

nmap_leader("m", function() return "mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm" end, "Remove the ^M Windows line endings")
nmap_leader("w", misc.save, "Save")
nmap_leader("/", "gcc", "Toggle comment line", { remap = true })
xmap_leader("/", "gcc", "Toggle comment", { remap = true })

nmap_leader("ld", function() vim.diagnostic.open_float() end, "Hover diagnostics")
nmap_leader("li", function() vim.cmd.checkhealth "vim.lsp" end, "Lsp Information")

nmap_leader("n", pickers.new_file, "New File")
nmap_leader("gw", pickers.worktrees, "Worktrees")
nmap_leader("Sc", misc.nvim_config, "Neovim Config")

-- List management
nmap_leader("xq", "<Cmd>copen<CR>", "Quickfix List")
nmap_leader("xl", "<Cmd>lopen<CR>", "Location List")

-- LocalLeader mappings ============================================================
Config.localleader_groups = {}
local nmap_localleader = function(suffix, rhs, desc) map("n", "<LocalLeader>" .. suffix, rhs, { desc = desc }) end
-- local xmap_localleader = function(suffix, rhs, desc) map("x", "<LocalLeader>" .. suffix, rhs, { desc = desc }) end

nmap_localleader(";", require("pickers").quick, "Quick Actions")
