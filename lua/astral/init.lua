---@class Config
---@field restore_colors boolean Enable or disable colorscheme restoration
---@field fallback_themes string[] List of fallback themes

local settings = require("astral.settings")
local autocommands = require("astral.autocommands")

local M = {}

---@type Config
M.config = {
  restore_colors = true, -- Default to true
  fallback_themes = { "catppuccin", "tokyonight", "default" }, -- Default fallback themes
}

-- Setup function to initialize the plugin
---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  settings.ensure_settings_file()
  settings.init_settings()
  settings.restore_colorscheme(M.config)

  autocommands.define_autocommands()
  M.define_commands()
end

function M.define_commands()
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
    complete = function(arg_lead)
      local commands = { "reset" }
      return vim.tbl_filter(function(cmd)
        return vim.startswith(cmd, arg_lead)
      end, commands)
    end,
  })
end

return M
