local astral = require("astral")

describe("setup", function()
  it("works with default", function()
    print("hello world")
  end)

  it("works with custom var", function()
    astral.setup({ restore_colors = true, fallback_themes = { "catppuccin", "tokyonight", "default" } })
    print("custom hello world")
  end)
end)
