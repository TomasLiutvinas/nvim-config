vim.api.nvim_create_user_command("TruncateEOF", function()
  local file = vim.fn.expand("%:p")
  if vim.fn.filereadable(file) == 0 then
    print("No file to truncate.")
    return
  end

  -- Save to ensure disk is up to date
  vim.cmd("write")

  -- Truncate the last byte
  vim.fn.system({ "truncate", "-s", "-1", file })

  -- Reload the file forcibly
  vim.cmd("edit!")

  -- Now preserve this state properly (prevent adding newline again)
  vim.bo.binary = true
  vim.bo.eol = false
  vim.bo.fixendofline = false

  -- Touch the buffer to convince nvim to respect the flags
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  print("Truncated final byte and preserved no-newline state: " .. file)
end, { desc = "Remove trailing newline from current file" })
