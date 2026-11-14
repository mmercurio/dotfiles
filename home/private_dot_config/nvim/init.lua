require("core.keymaps")
require("config.lazy")

-- TODO move below into "core.post-init" or similar
-- restore corsorcolumn color (must be loaded after colorscheme)
vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine" })

