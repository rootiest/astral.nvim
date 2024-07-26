# astral.nvim

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/rootiest/astral.nvim/lint-test.yml?branch=main&style=for-the-badge)
![Lua](https://img.shields.io/badge/Made%20with%20Lua-blueviolet.svg?style=for-the-badge&logo=lua)
[![Astral.nvim](https://dotfyle.com/plugins/rootiest/astral.nvim/shield?style=for-the-badge)](https://dotfyle.com/plugins/rootiest/astral.nvim)

![Astral](astral.png)

`astral.nvim` is a Neovim plugin for colorscheme management.

## Features

- Remembers the last used colorscheme and restores it when Neovim opens.

## Installation

Using `lazy.nvim`, add the plugin to your configuration:

```lua
require("lazy").setup({
    {
        "astral/astral.nvim",
        version = "*",
    },
})
```

## Configuration

You can configure the `astral` plugin by passing a table of options to `require("astral").setup()`.

### Default Values

The default values for `astral` configuration are:

```lua
local config = {
    restore_colors = true, -- Enable or disable automatic colorscheme restoration
}
```

### Example Configuration

To manually set all default values (though they are already set by default),
use the following `lazy.nvim` configuration:

```lua
require("lazy").setup({
    {
        "astral/astral.nvim",
        version = "*",
        opts = {
            restore_colors = true, -- Set to false to disable colorscheme restoration
        }
    },
})
```

## Commands

- **`:Astral reset`**: Reset the colorscheme management.

## Autocommands

- **ColorScheme**: Store the new name when the colorscheme changes.

## License

`astral.nvim` is licensed under the MIT License. See [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome!
Please open an issue or submit a pull request to the
[GitHub repository](https://github.com/astral/astral.nvim).
