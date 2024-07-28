local M = {}

function M.define_autocommands()
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Store colorscheme name",
    callback = function()
      vim.g.COLORTHEME = vim.g.colors_name
    end,
  })
end

return M
