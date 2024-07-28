local astral = require("astral")

describe("setup", function()
  before_each(function()
    -- Clear any previous state
    vim.g.COLORTHEME = nil
    package.loaded["astral"] = nil
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

  it("restores colorscheme from vim.g.COLORTHEME", function()
    vim.g.COLORTHEME = "gruvbox"
    astral.setup()
    assert.are.equal("gruvbox", vim.g.colors_name)
  end)
end)
