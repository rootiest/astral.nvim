---@class Config
---@field fallback_themes string[] List of fallback themes

local autocommands = require("astral.autocommands")

local M = {}

M.config = {
  fallback_themes = { "catppuccin", "tokyonight", "default" },
}

-- Setup function to initialize the plugin
---@param args table
function M.setup(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})
  M.restore_colorscheme()
  autocommands.define_autocommands()
  M.define_commands()
end

function M.define_commands()
  vim.api.nvim_create_user_command("Astral", function(params)
    if params.args == "reset" then
      M.reset_colorscheme()
    elseif params.args == "restore" then
      M.restore_colorscheme()
    else
      vim.api.nvim_err_writeln("Unknown Astral command: " .. params.args)
    end
  end, {
    nargs = 1,
    force = true,
    desc = "Astral command group",
    complete = function(arg_lead)
      local commands = { "reset", "restore" }
      return vim.tbl_filter(function(cmd)
        return vim.startswith(cmd, arg_lead)
      end, commands)
    end,
  })
end

function M.restore_colorscheme()
  local function is_colorscheme_available(name)
    local ok, _ = pcall(function()
      vim.cmd("colorscheme " .. name)
    end)
    return ok
  end

  local colortheme = vim.g.COLORTHEME
  if colortheme and is_colorscheme_available(colortheme) then
    vim.cmd("colorscheme " .. colortheme)
  else
    for _, theme in ipairs(M.config.fallback_themes) do
      if is_colorscheme_available(theme) then
        vim.cmd("colorscheme " .. theme)
        vim.g.COLORTHEME = theme
        break
      end
    end
  end
end

function M.reset_colorscheme()
  for _, theme in ipairs(M.config.fallback_themes) do
    if pcall(function()
      vim.cmd("colorscheme " .. theme)
    end) then
      vim.g.COLORTHEME = theme
      break
    end
  end
end

return M
