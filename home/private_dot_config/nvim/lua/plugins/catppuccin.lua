return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")

      -- Apply transparency to the main editor background
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE", ctermbg = "NONE" })

      vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#2a2b3c" })
    end,
  },
}
