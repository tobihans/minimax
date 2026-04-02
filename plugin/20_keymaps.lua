local pickers = require "pickers"
local misc = require "misc"

-- General mappings ===========================================================
local map = vim.keymap.set
local nmap = function(lhs, rhs, desc, opts) map("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local xmap = function(lhs, rhs, desc, opts) map("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end

nmap("[p", '<Cmd>exe "iput! " . v:register<CR>', "Paste Above")
nmap("]p", '<Cmd>exe "iput "  . v:register<CR>', "Paste Below")
nmap("0", "^", "First non-blank character")

nmap("<M-Up>", "<Cmd>resize -2<CR>", "Resize split up")
nmap("<M-Down>", "<Cmd>resize +2<CR>", "Resize split down")
nmap("<M-Left>", "<Cmd>vertical resize -2<CR>", "Resize split left")
nmap("<M-Right>", "<Cmd>vertical resize +2<CR>", "Resize split right")

nmap("j", "v:count == 0 ? 'gj' : 'j'", "Move cursor down", { expr = true, silent = true })
xmap("j", "v:count == 0 ? 'gj' : 'j'", "Move cursor down", { expr = true, silent = true })
nmap("k", "v:count == 0 ? 'gk' : 'k'", "Move cursor up", { expr = true, silent = true })
xmap("k", "v:count == 0 ? 'gk' : 'k'", "Move cursor up", { expr = true, silent = true })

nmap("|", "<Cmd>vsplit<CR>", "Vertical Split")
nmap("\\", "<Cmd>split<CR>", "Horizontal Split")

nmap("gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", "Add Comment Below")
nmap("gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", "Add Comment Above")

-- Leader mappings ============================================================
Config.leader_groups = {
  { "<Leader>s", group = "󰛔 Search/Replace" },
}
local nmap_leader = function(suffix, rhs, desc, opts) nmap("<Leader>" .. suffix, rhs, { desc = desc }, opts) end

nmap_leader("n", pickers.new_file, "New File")
nmap_leader("m", function() return "mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm" end, "Remove the ^M Windows line endings")
nmap_leader("w", misc.save, "Save")
nmap_leader("gw", pickers.worktrees, "Worktrees")
nmap_leader("Sc", misc.nvim_config, "Neovim Config")

-- LocalLeader mappings ============================================================
Config.localleader_groups = {}
local nmap_localleader = function(suffix, rhs, desc) map("n", "<LocalLeader>" .. suffix, rhs, { desc = desc }) end
-- local xmap_localleader = function(suffix, rhs, desc) map("x", "<LocalLeader>" .. suffix, rhs, { desc = desc }) end

nmap_localleader(";", require("pickers").quick, "Quick Actions")
