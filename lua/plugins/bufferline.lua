-- import plugin safely
local setup, bufferline = pcall(require, "bufferline")
if not setup then
  return
end

bufferline.setup({
  options = {
    middle_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
    hover = {
      enabled = true,
      delay = 200,
      reveal = { "close" },
    },
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true, -- use a "true" to enable the default, or set your own character
      },
    },
    max_name_length = 25,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 10,
    show_buffer_icons = false,
  },
})

vim.opt.sessionoptions:append({ "globals" })

local keymap = vim.keymap
keymap.set("n", "]b", "<Cmd>BufferLineCycleNext<CR>", { silent = true, noremap = true })
keymap.set("n", "[b", "<Cmd>BufferLineCyclePrev<CR>", { silent = true, noremap = true })
keymap.set("n", "<leader>]b", "<Cmd>BufferLineMoveNext<CR>", { silent = true, noremap = true })
keymap.set("n", "<leader>[b", "<Cmd>BufferLineMovePrev<CR>", { silent = true, noremap = true })

keymap.set("n", "<M-S-l>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
keymap.set("n", "<M-S-h>", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
keymap.set("n", "<C-M-S-l>", "<Cmd>BufferLineMoveNext<CR>", { silent = true, noremap = true })
keymap.set("n", "<C-M-S-h>", "<Cmd>BufferLineMovePrev<CR>", { silent = true, noremap = true })

-- {{{ Smart buffers/tabs switch
local tab_switcher_mode = "buffers"
function ToggleTabSwitcherMode()
  if tab_switcher_mode == "buffers" then
    keymap.set("n", "<M-S-l>", "<Cmd>tabnext<CR>", { noremap = true, silent = true })
    keymap.set("n", "<M-S-h>", "<Cmd>tabprevious<CR>", { noremap = true, silent = true })
    tab_switcher_mode = "tabs"
    print("Switch tabs")
  else
    keymap.set("n", "<M-S-l>", "<Cmd>BufferLineCycleNext<CR>", { noremap = true, silent = true })
    keymap.set("n", "<M-S-h>", "<Cmd>BufferLineCyclePrev<CR>", { noremap = true, silent = true })
    tab_switcher_mode = "buffers"
    print("Switch buffers")
  end
end
keymap.set(
  "n",
  "<leader><Tab>",
  "<CMD>lua ToggleTabSwitcherMode()<CR>",
  { silent = true, noremap = true }
)
-- }}}
