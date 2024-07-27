local M = {}

function M.astral_complete(arg_lead, _cmd_line, _cursor_pos)
  local commands = { "reset" }
  return vim.tbl_filter(function(cmd)
    return vim.startswith(cmd, arg_lead)
  end, commands)
end

function M.define_commands()
  local settings = require("astral.settings")

  vim.api.nvim_create_user_command("Astral", function(params)
    if params.args == "reset" then
      settings.reset_colorscheme()
    else
      vim.api.nvim_err_writeln("Unknown Astral command: " .. params.args)
    end
  end, {
    nargs = 1,
    force = true,
    desc = "Astral command group",
    complete = M.astral_complete,
  })
end

return M
