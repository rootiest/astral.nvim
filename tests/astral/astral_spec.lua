local astral = require("astral")

local function reload()
  for name, _ in pairs(package.loaded) do
    if name:match("^astral") then
      package.loaded[name] = nil
    end
  end
  vim.g.COLORTHEME = nil
end

describe("setup", function()
  before_each(function()
    -- Clear any previous state
    reload()
    astral = require("astral")
  end)
  it("works with default", function()
    astral.setup()
    print("Test successful")
  end)

  it("works with custom var", function()
    astral.setup({ fallback_themes = { "catppuccin", "tokyonight", "default" } })
    print("Test successful")
  end)
end)

describe("astral commands", function()
  before_each(function()
    -- Clear any previous state
    reload()
    astral = require("astral")
  end)
  it("reset", function()
    astral.setup()
    vim.cmd("Astral reset")
    print("Test successful")
  end)
  it("reload", function()
    astral.setup()
    vim.cmd("Astral reload")
    print("Test successful")
  end)
end)

describe("astral themes", function()
  before_each(function()
    -- Clear any previous state
    reload()
    astral = require("astral")
  end)
  it("works with default", function()
    astral.setup()
    assert.equals(vim.g.COLORTHEME, vim.g.colors_name)
    print("Test successful")
  end)
  it("works with custom theme", function()
    vim.g.COLORTHEME = "tokyonight"
    astral.setup()
    assert.equals("tokyonight", vim.g.colors_name)
    print("Test successful")
  end)
end)
