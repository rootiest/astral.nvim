vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Load Astral",
  callback = function()
    require("astral").setup()
  end,
})
