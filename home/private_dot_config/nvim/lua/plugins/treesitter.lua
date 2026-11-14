return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    require("nvim-treesitter").install({
      "lua",
      "bash",
      "html",
      "java",
      "javascript",
      "json",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "ruby",
      "vim",
      "yaml",
    })

    -- Autoclose HTML tags
    require("nvim-ts-autotag").setup()
  end,
}
