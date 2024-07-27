local M = {}

function M.define_autocommands()
  local settings = require("astral.settings")

  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Store colorscheme name",
    callback = function()
      local ok = pcall(function()
        settings.save_settings() -- Save the current colorscheme
      end)
      if not ok then
        vim.api.nvim_err_writeln("Failed to save colorscheme")
      end
    end,
  })
end

return M
