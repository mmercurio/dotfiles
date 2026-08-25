return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin-mocha")

      vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2a2b3c" })
    end,
  },
}
