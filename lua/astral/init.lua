local M = {}

local data_path = vim.fn.stdpath("data") .. "/lazy/astral.nvim"
local settings_file = data_path .. "/settings.json"
local current_colorscheme = vim.g.colors_name -- Local variable for tracking colorscheme

-- Ensure the settings file exists with default values
function M.ensure_settings_file()
  if vim.fn.isdirectory(data_path) ~= 1 then
    vim.fn.mkdir(data_path, "p")
  end

  if vim.fn.filereadable(settings_file) ~= 1 then
    local json = vim.fn.json_encode({ colorscheme = current_colorscheme })
    vim.fn.writefile({ json }, settings_file)
  end
end

-- Load settings from the settings file
function M.load_settings()
  local json_content = vim.fn.readfile(settings_file)[1]
  if not json_content then
    M.ensure_settings_file()
    json_content = vim.fn.readfile(settings_file)[1]
  end
  local settings = vim.fn.json_decode(json_content)
  if settings.colorscheme then
    current_colorscheme = settings.colorscheme
  end
end

-- Save settings to the settings file
function M.save_settings()
  local json = vim.fn.json_encode({ colorscheme = current_colorscheme })
  vim.fn.writefile({ json }, settings_file)
end

-- Reset colorscheme in the settings file
function M.reset_colorscheme()
  local json_content = vim.fn.readfile(settings_file)[1]
  if json_content then
    local settings = vim.fn.json_decode(json_content)
    settings.colorscheme = nil
    local json = vim.fn.json_encode(settings)
    vim.fn.writefile({ json }, settings_file)
  end
end

-- Initialize settings
function M.init_settings()
  M.load_settings()
end

-- Restore colorscheme based on `restore_colors` option
function M.restore_colorscheme()
  if M.config.restore_colors == false then
    return
  end

  local function is_colorscheme_available(name)
    local ok, _ = pcall(function()
      vim.cmd("colorscheme " .. name)
    end)
    return ok
  end

  local colortheme = current_colorscheme
  local fallback_themes = { "catppuccin-frappe", "tokyonight", "default" }

  if colortheme and is_colorscheme_available(colortheme) then
    vim.cmd.colorscheme(colortheme)
  else
    for _, theme in ipairs(fallback_themes) do
      if is_colorscheme_available(theme) then
        vim.cmd.colorscheme(theme)
        break
      end
    end
  end
end

-- Define autocommands
function M.define_autocommands()
  -- Autosave Colorscheme
  -- When the colorscheme changes, store the name in .colorscheme
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Store colorscheme name",
    callback = function()
      current_colorscheme = vim.g.colors_name
      M.save_settings()
    end,
  })
end

-- Completion function for Astral commands
---@diagnostic disable-next-line: unused-local
function M.astral_complete(arg_lead, _cmd_line, _cursor_pos)
  local commands = { "reset" }
  return vim.tbl_filter(function(cmd)
    return vim.startswith(cmd, arg_lead)
  end, commands)
end

-- Define user commands
function M.define_commands()
  vim.api.nvim_create_user_command("Astral", function(params)
    if params.args == "reset" then
      M.reset_colorscheme()
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

---@class Config
---@field restore_colors boolean Enable or disable colorscheme restoration
local config = {
  restore_colors = true, -- Default to true
}

---@type Config
M.config = config

-- Setup function to initialize the plugin
---@param args Config?
M.setup = function(args)
  M.config = vim.tbl_deep_extend("force", M.config, args or {})

  M.ensure_settings_file()
  M.init_settings()

  if M.config.restore_colors then
    M.restore_colorscheme()
  end

  M.define_autocommands()
  M.define_commands()
end

return M
