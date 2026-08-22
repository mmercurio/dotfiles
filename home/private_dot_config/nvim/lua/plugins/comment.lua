return {
  -- "numToStr/Comment.nvim",
  --    patched for nvim 0.12 until PR is merged:
  --    https://github.com/numToStr/Comment.nvim/pull/521
  "neovim-plugins/comment.nvim",
  branch = "fix/patch-treesitter",

  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  config = function()
    -- import comment plugin safely
    local comment = require("Comment")

    local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

    comment.setup({
      pre_hook = ts_context_commentstring.create_pre_hook(),
    })
  end,
}
