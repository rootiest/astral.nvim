local astral = require("astral")

describe("Astral plugin setup", function()
  before_each(function()
    -- Clear any previous state
    vim.g.COLORTHEME = nil
    package.loaded["astral"] = nil
    astral = require("astral")
  end)

  it("uses default configuration", function()
    astral.setup({})
    assert.are.same({ "catppuccin", "tokyonight", "default" }, astral.config.fallback_themes)
  end)

  it("overrides default configuration with custom values", function()
    local custom_themes = { "gruvbox", "onedark" }
    astral.setup({ fallback_themes = custom_themes })
    assert.are.same(custom_themes, astral.config.fallback_themes)
  end)

  it("restores colorscheme from vim.g.COLORTHEME", function()
    vim.g.COLORTHEME = "gruvbox"
    astral.setup({ fallback_themes = { "catppuccin", "tokyonight", "default" } })
    astral.restore_colorscheme()
    assert.are.equal("gruvbox", vim.g.colors_name)
  end)

  it("falls back to default themes if COLORTHEME is not set or unavailable", function()
    vim.g.COLORTHEME = nil
    astral.setup({ fallback_themes = { "gruvbox", "onedark" } })
    astral.restore_colorscheme()
    local colortheme = vim.g.colors_name
    assert.is_true(colortheme == "gruvbox" or colortheme == "onedark")
  end)
end)
