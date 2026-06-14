return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    }
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      ensure_installed = { "lua_ls", "ts_ls" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    vim.lsp.config("ts_ls", {}),
    vim.lsp.enable("ts_ls", {}),

    vim.lsp.config("lua_ls", {}),
    vim.lsp.enable({"lua_ls"}),

    vim.lsp.config("pyright", {}),
    vim.lsp.enable({"pyright"}),

    -- Toggle diagnostic virtual text
    -- vim.diagnostic.config({ virtual_text = true }),
    vim.keymap.set('n', '<leader>lt', function()
      local config = vim.diagnostic.config() or {}
      local toggle_virtual_text = not config.virtual_text
      vim.diagnostic.config({ virtual_text = toggle_virtual_text })
    end, { desc = 'Toggle LSP virtual text' }),

    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Show LSP diagnostics under cursor" }),
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" }),
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" }),
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "List implementations" }),
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" }),

      }
    }
