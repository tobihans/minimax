local pickers = require "pickers"
local misc = require "misc"

-- General mappings ===========================================================
local map = vim.keymap.set
local nmap = function(lhs, rhs, desc, opts) map("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local xmap = function(lhs, rhs, desc, opts) map("n", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local vmap = function(lhs, rhs, desc, opts) map("v", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local imap = function(lhs, rhs, desc, opts) map("i", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end
local tmap = function(lhs, rhs, desc, opts) map("t", lhs, rhs, vim.tbl_extend("force", { desc = desc }, opts or {})) end

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
nmap("]t", function() vim.cmd.tabnext() end, "Next tab")
nmap("[t", function() vim.cmd.tabprevious() end, "Previous tab")

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

nmap_leader("e", "<Cmd>Neotree toggle<CR>", "Toggle Explorer")
nmap_leader("n", pickers.new_file, "New File")
nmap_leader("gw", pickers.worktrees, "Worktrees")
nmap_leader("gI", function() Snacks.picker.gh_issue() end, "GitHub Issues (open)")
nmap_leader("gP", function() Snacks.picker.gh_pr() end, "GitHub Pull Requests (open)")
nmap_leader(":", function() Snacks.picker.command_history() end, "Command History")
nmap_leader("Sc", misc.nvim_config, "Neovim Config")

-- List management
nmap_leader("xq", "<Cmd>copen<CR>", "Quickfix List")
nmap_leader("xl", "<Cmd>lopen<CR>", "Location List")

-- Session management
nmap_leader("Sl", function() require("resession").load "Last Session" end, "Load last session")
nmap_leader(
  "SS",
  function() require("resession").save(vim.fn.getcwd(), { dir = "dirsession" }) end,
  "Save this dirsession"
)
nmap_leader("SD", function() require("resession").delete(nil, { dir = "dirsession" }) end, "Delete a dirsession")
nmap_leader("SF", function() require("resession").load(nil, { dir = "dirsession" }) end, "Load a dirsession")
nmap_leader(
  "S.",
  function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
  "Load current dirsession"
)

-- LocalLeader mappings ============================================================
Config.localleader_groups = {}
local nmap_localleader = function(suffix, rhs, desc, opts) nmap("<LocalLeader>" .. suffix, rhs, desc, opts) end
-- local xmap_localleader = function(suffix, rhs, desc) map("x", "<LocalLeader>" .. suffix, rhs, { desc = desc }) end

nmap_localleader(";", require("pickers").quick, "Quick Actions")
nmap_localleader(".", function() Snacks.scratch() end, "Toggle Scratch Buffer")
nmap_localleader("S", function() Snacks.scratch.select() end, "Select Scratch Buffer")

-- Terminal ===================================================================
local terminal = function() Snacks.terminal.toggle() end
nmap_leader("th", terminal, "Toggle terminal")
nmap("<F7>", terminal, "Toggle terminal")
tmap("<F7>", terminal, "Toggle terminal")
imap("<F7>", terminal, "Toggle terminal")

-- Improved Terminal Navigation
local term_nav = require("terminal").term_nav
tmap("<C-H>", term_nav "h", "Terminal left window navigation")
tmap("<C-J>", term_nav "j", "Terminal down window navigation")
tmap("<C-K>", term_nav "k", "Terminal up window navigation")
tmap("<C-L>", term_nav "l", "Terminal right window navigation")

nmap_leader("gg", function() Snacks.terminal.toggle "mise x -- lazygit" end, "Lazygit")
nmap_leader("tl", function() Snacks.terminal.toggle "mise x -- lazygit" end, "Lazygit")
nmap_leader("td", function() Snacks.terminal.toggle "mise x -- lazydocker" end, "Lazydocker")
nmap_leader("tn", function() Snacks.terminal.toggle "mise x -- node" end, "Node REPL")

local gdu = "gdu"
if vim.fn.executable(gdu) ~= 1 then
  if vim.fn.has "win32" == 1 then
    gdu = "gdu_windows_amd64.exe"
  elseif vim.fn.has "mac" == 1 then
    gdu = "gdu-go"
  end
end
if vim.fn.executable(gdu) == 1 then
  nmap_leader("tu", function() Snacks.terminal.toggle(gdu) end, "Disk usage (gdu)")
end

if vim.fn.executable "btop" == 1 then
  nmap_leader("tt", function() Snacks.terminal.toggle "btop" end, "System stats (btop)")
end

local python = vim.fn.executable "python" == 1 and "python" or vim.fn.executable "python3" == 1 and "python3"
if python then nmap_leader("tp", function() Snacks.terminal.toggle("mise x -- " .. python) end, "Python REPL") end

-- Snacks =====================================================================
-- Dashboard
nmap_leader("h", function()
  if vim.bo.filetype == "snacks_dashboard" then
    vim.cmd "bdelete"
  else
    Snacks.dashboard()
  end
end, "Home Screen")

-- Picker: Find
nmap_leader("f<CR>", function() Snacks.picker.resume() end, "Resume previous search")
nmap_leader("f'", function() Snacks.picker.marks() end, "Find marks")
nmap_leader("fl", function() Snacks.picker.lines() end, "Find lines")
nmap_leader(
  "fa",
  function() Snacks.picker.files { dirs = { vim.fn.stdpath "config" }, desc = "Config Files" } end,
  "Find config files"
)
nmap_leader("fb", function() Snacks.picker.buffers() end, "Find buffers")
nmap_leader("fc", function() Snacks.picker.grep_word() end, "Find word under cursor")
nmap_leader("fC", function() Snacks.picker.commands() end, "Find commands")
nmap_leader(
  "ff",
  function()
    Snacks.picker.files {
      hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat ".git" or {}, "type") == "directory",
    }
  end,
  "Find files"
)
nmap_leader("fF", function() Snacks.picker.files { hidden = true, ignored = true } end, "Find all files")
nmap_leader("fh", function() Snacks.picker.help() end, "Find help")
nmap_leader("fk", function() Snacks.picker.keymaps() end, "Find keymaps")
nmap_leader("fm", function() Snacks.picker.man() end, "Find man")
nmap_leader("fn", function() Snacks.picker.notifications() end, "Find notifications")
nmap_leader("fo", function() Snacks.picker.recent() end, "Find old files")
nmap_leader("fO", function() Snacks.picker.recent { filter = { cwd = true } } end, "Find old files (cwd)")
nmap_leader("fp", function() Snacks.picker.projects() end, "Find projects")
nmap_leader("fr", function() Snacks.picker.registers() end, "Find registers")
nmap_leader("fs", function() Snacks.picker.smart() end, "Find buffers/recent/files")
nmap_leader("ft", function() Snacks.picker.colorschemes() end, "Find themes")
nmap_leader("fu", function() Snacks.picker.undo() end, "Find undo history")

if vim.fn.executable "rg" == 1 then
  nmap_leader("fw", function() Snacks.picker.grep() end, "Find words")
  nmap_leader("fW", function() Snacks.picker.grep { hidden = true, ignored = true } end, "Find words in all files")
end

-- Picker: Git
if vim.fn.executable "git" == 1 then
  nmap_leader("gb", function() Snacks.picker.git_branches() end, "Git branches")
  nmap_leader("gc", function() Snacks.picker.git_log() end, "Git commits (repository)")
  nmap_leader(
    "gC",
    function() Snacks.picker.git_log { current_file = true, follow = true } end,
    "Git commits (current file)"
  )
  nmap_leader("go", function() Snacks.gitbrowse() end, "Git browse (open)")
  nmap_leader("gt", function() Snacks.picker.git_status() end, "Git status")
  nmap_leader("gT", function() Snacks.picker.git_stash() end, "Git stash")
  nmap_leader("fg", function() Snacks.picker.git_files() end, "Find git files")
end

-- Picker: LSP
nmap_leader("lD", function() Snacks.picker.diagnostics() end, "Search diagnostics")
nmap_leader("ls", function() Snacks.picker.lsp_symbols() end, "Search symbols")

-- LSP (AstroNvim-style) =====================================================
nmap_leader("la", function() vim.lsp.buf.code_action() end, "LSP code action")
vmap("<Leader>la", function() vim.lsp.buf.code_action() end, "LSP code action")
nmap_leader(
  "lA",
  function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end,
  "LSP source action"
)
nmap_leader("ll", function() vim.lsp.codelens.enable(true) end, "LSP CodeLens refresh")
nmap_leader("lL", function() vim.lsp.codelens.run() end, "LSP CodeLens run")
nmap_leader("lf", function() vim.lsp.buf.format { async = true } end, "Format buffer")
vmap("<Leader>lf", function() vim.lsp.buf.format { async = true } end, "Format buffer")
nmap_leader("lR", function() vim.lsp.buf.references() end, "Search references")
nmap_leader("lr", function() vim.lsp.buf.rename() end, "Rename current symbol")
nmap_leader("lh", function() vim.lsp.buf.signature_help() end, "Signature help")
nmap_leader("lG", function() vim.lsp.buf.workspace_symbol() end, "Search workspace symbols")

nmap("gD", function() vim.lsp.buf.declaration() end, "Declaration of current symbol")
nmap("gd", function() vim.lsp.buf.definition() end, "Definition of current symbol")
nmap("gK", function() vim.lsp.buf.signature_help() end, "Signature help")
nmap("gy", function() vim.lsp.buf.type_definition() end, "Definition of current type")

-- LSP Toggles
nmap_leader("uf", function()
  vim.b.autoformat = not vim.b.autoformat
  vim.notify("Buffer autoformat: " .. (vim.b.autoformat and "on" or "off"))
end, "Toggle autoformatting (buffer)")
nmap_leader("uF", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Global autoformat: " .. (vim.g.autoformat and "on" or "off"))
end, "Toggle autoformatting (global)")
nmap_leader("uL", function()
  local enabled = vim.lsp.codelens.enable(not vim.lsp.codelens.enable())
  vim.notify("CodeLens: " .. (enabled and "on" or "off"))
end, "Toggle CodeLens")
nmap_leader(
  "uh",
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 }) end,
  "Toggle inlay hints (buffer)"
)
nmap_leader(
  "uH",
  function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
  "Toggle inlay hints (global)"
)
nmap_leader("uY", function()
  if vim.lsp.semantic_tokens then
    vim.b.semantic_tokens = not vim.b.semantic_tokens
    vim.notify("Semantic tokens: " .. (vim.b.semantic_tokens ~= false and "on" or "off"))
  end
end, "Toggle semantic highlighting (buffer)")

-- Toggles
nmap_leader("u|", function() Snacks.toggle.indent():toggle() end, "Toggle indent guides")
nmap_leader("uD", function() Snacks.notifier.hide() end, "Dismiss notifications")
nmap_leader("ur", function() Snacks.toggle.words():toggle() end, "Toggle reference highlighting")
nmap_leader("uZ", function() Snacks.toggle.zen():toggle() end, "Toggle zen mode")

-- Words
nmap("]r", function() Snacks.words.jump(vim.v.count1) end, "Next reference")
nmap("[r", function() Snacks.words.jump(-vim.v.count1) end, "Previous reference")

-- Buffers
nmap_leader("C", function() require("buffer").close(0, true) end, "Force close buffer")
nmap_leader("c", function() require("buffer").close() end, "Close buffer")
