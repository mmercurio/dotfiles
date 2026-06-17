return {
  "nvimtools/none-ls.nvim",
  -- null-ls wraps CLI tools for use with lsp such as formatters.
  -- This allows CLI formatting tools to be used as LSP formatters.
  -- e.g., for Python, we could use isort and black here.
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua, -- stylua config is stylua.toml
        null_ls.builtins.formatting.prettier,
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer (Lua)" })
  end,
}
