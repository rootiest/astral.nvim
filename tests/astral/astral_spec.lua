local astral = require("astral")

describe("setup", function()
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
    astral.restore_colorscheme()
    assert.are.equal("gruvbox", vim.g.colors_name)
  end)
end)
