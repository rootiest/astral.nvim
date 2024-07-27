local M = {}
local data_path = vim.fn.stdpath("data") .. "/lazy/astral.nvim"
local settings_file = data_path .. "/settings.json"

-- Ensure the settings file exists with default values
function M.ensure_settings_file()
  if vim.fn.isdirectory(data_path) ~= 1 then
    vim.fn.mkdir(data_path, "p")
  end

  local file = io.open(settings_file, "r")
  if not file then
    local json = vim.fn.json_encode({ colorscheme = vim.g.colors_name })
    file = io.open(settings_file, "w")
    if file then
      file:write(json)
      file:close()
    end
  end
end

-- Load settings from the settings file
function M.load_settings()
  local file = io.open(settings_file, "r")
  if file then
    local json_content = file:read("*a")
    file:close()
    local ok, settings = pcall(vim.fn.json_decode, json_content)
    if ok and settings and settings.colorscheme then
      vim.g.colors_name = settings.colorscheme
    end
  else
    M.ensure_settings_file()
    M.load_settings()
  end
end

-- Save settings to the settings file
function M.save_settings()
  local json = vim.fn.json_encode({ colorscheme = vim.g.colors_name })
  local file = io.open(settings_file, "w")
  if file then
    file:write(json)
    file:close()
  end
end

-- Reset colorscheme in the settings file
function M.reset_colorscheme()
  local file = io.open(settings_file, "r")
  if file then
    local json_content = file:read("*a")
    file:close()
    local ok, settings = pcall(vim.fn.json_decode, json_content)
    if ok and settings then
      settings.colorscheme = nil
      local json = vim.fn.json_encode(settings)
      file = io.open(settings_file, "w")
      if file then
        file:write(json)
        file:close()
      end
    end
  end
end

-- Initialize settings
function M.init_settings()
  M.load_settings()
end

-- Restore colorscheme based on `restore_colors` option
function M.restore_colorscheme(config)
  if config.restore_colors == false then
    return
  end

  local function is_colorscheme_available(name)
    local ok, _ = pcall(function()
      vim.cmd("colorscheme " .. name)
    end)
    return ok
  end

  local colortheme = vim.g.colors_name
  local fallback_themes = config.fallback_themes or { "catppuccin", "tokyonight", "default" }

  if colortheme and is_colorscheme_available(colortheme) then
    vim.cmd("colorscheme " .. colortheme)
  else
    for _, theme in ipairs(fallback_themes) do
      if is_colorscheme_available(theme) then
        vim.cmd("colorscheme " .. theme)
        break
      end
    end
  end
end

return M
