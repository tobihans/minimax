local M = {}

function M.nvim_config()
  require("resession").load(vim.fn.stdpath "config", {
    dir = "dirsession",
    reset = true,
    silence_errors = false,
  })
end
function M.save()
  if vim.fn.getreg "%" == "" then
    vim.ui.input({ prompt = "Path: ", completion = "file" }, function(input)
      if input then vim.cmd.write { input, bang = true } end
    end)
  else
    vim.cmd.write()
  end
end

return M
