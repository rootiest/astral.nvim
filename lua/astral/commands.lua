local M = {}

function M.astral_complete(arg_lead)
  local commands = { "reset", "restore" }
  return vim.tbl_filter(function(cmd)
    return vim.startswith(cmd, arg_lead)
  end, commands)
end

function M.define_commands()
  local settings = require("astral.settings")
  local astral = require("astral")

  vim.api.nvim_create_user_command("Astral", function(params)
    if params.args == "reset" then
      settings.reset_colorscheme()
    elseif params.args == "restore" then
      astral.setup(astral.config)
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
