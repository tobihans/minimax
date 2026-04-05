local M = {}

--- Check if a buffer is valid
---@param bufnr? integer The buffer to check, default to current buffer
---@return boolean # Whether the buffer is valid or not
function M.is_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Check if a buffer can be restored
---@param bufnr integer The buffer to check
---@return boolean # Whether the buffer is restorable or not
function M.is_restorable(bufnr)
  if not M.is_valid(bufnr) or vim.bo[bufnr].bufhidden ~= "" then return false end

  -- Check if it has a filename.
  if vim.api.nvim_buf_get_name(bufnr) == "" then return false end
  -- TODO: Add a check for local buffer option vim.b.is_restorable.

  return vim.bo[bufnr].buflisted
end

return M
