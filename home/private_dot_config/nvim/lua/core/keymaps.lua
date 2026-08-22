vim.opt.autoindent = true
vim.opt.cursorline = true
-- cursorcolumn maybe? not needed with indent-blankline plugin
vim.opt.cursorcolumn = true
vim.opt.number = true
-- vim.opt.relativenumber = true

-- default indentation is 4 spaces
--    filetype specific under ./ftplugin/<filetype>
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.softtabstop = 4

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.scrolloff = 8

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.o.winborder = 'rounded'

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep separate from system clipboard
-- See keymapping below to use <leader>y and <leader>p
-- vim.opt.clipboard:append("unnamedplus")

-- allows trailing whitespace to be visible
vim.o.list = true
vim.o.listchars = 'tab:» ,trail:•,nbsp:␣'

-- Python placement of open/close parens/braces
vim.g.python_indent = {
  open_paren = 'shiftwidth()',              -- Indent content by 1 level
  nested_paren = 'shiftwidth()',            -- Indent nested lines by 1 level
  continue = 'shiftwidth()',                -- Indent continuation lines by 1 level
  closed_paren_align_last_line = false      -- Align closing brace with the START of the line (conf)
}

-- treat *.sh.txt like *.sh
vim.filetype.add({
  pattern = {
    [".*%.sh%.txt"] = "sh",
  }
})

--
-- keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = ' '

vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

vim.keymap.set("n", "<leader>y", "", { desc = "Clear search highlights" })
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Substitute word under cursor
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word under cursor" })

-- [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
-- Remove trailing whitespace
--    https://vim.fandom.com/wiki/Remove_unwanted_spaces
--    https://vi.stackexchange.com/a/2285/35205
--` Original vimscript:`
-- local function TrimWhitespace()
--   local save_view = vim.fn.winsaveview()
--   vim.cmd([[keeppatterns %s/\s\+$//e]])
--   vim.fn.winrestview(save_view)
-- end
-- Lua version:
local function TrimWhitespace()
  local bufnr = 0
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local changed = false

  for i, line in ipairs(lines) do
    local new_line = line:gsub('%s+$', '')
    if new_line ~= line then
      lines[i] = new_line
      changed = true
    end
  end

  if changed then
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    -- Adjust cursor column if the line became shorter
    local current_line = vim.api.nvim_buf_get_lines(bufnr, cursor[1]-1, cursor[1], false)[1]
    if current_line then
      local max_col = #current_line
      cursor[2] = math.min(cursor[2], max_col)
      vim.api.nvim_win_set_cursor(0, cursor)
    end
  end
end

vim.keymap.set("n", "<leader>w", TrimWhitespace, { desc = "Trim trailing whitespace" })


-- TODO: these highlight and color settings should be moved into a colorscheme module
-- currently: under lua/plugins/catppuccin.lua (rename to colors.lua or similar)

-- Highlight trailing whitespace, migrated from .vimrc:
--   Show trailing whitespace, except when typing at the end of a line.
--   Create highlight group for extra whitespace.
--   https://vim.fandom.com/wiki/Highlight_unwanted_spaces
vim.cmd([[
  match ExtraWhitespace /\s\+\%#\@<!$/
  highlight ExtraWhitespace ctermbg=red guibg=red
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
]])

-- from kickstart.nvim
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})


--
-- Toggle colorcolumn with <leader>cc
--
local color_cols = "80,120"
vim.keymap.set("n", "<leader>cc", function()
  vim.wo.colorcolumn = (vim.wo.colorcolumn == color_cols) and "" or color_cols
end, { silent = true, desc = "Toggle colorcolumn" })
