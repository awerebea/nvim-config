-- set colorscheme with protected call in case it isn't installed
local status, _ = pcall(vim.cmd, "colorscheme nightfox")
if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end

require("nightfox").setup({
  options = {
    transparent = true, -- Disable setting background
  },
})

vim.cmd("colorscheme nordfox")

-- Common colorschemes options
-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { fg = "NONE", bg = "NONE" })
-- Transparent line number column
vim.api.nvim_set_hl(0, "LineNr", { fg = "NONE", bg = "NONE" })
-- Transparent sign (Git/mark) column
vim.api.nvim_set_hl(0, "SignColumn", { fg = "NONE", bg = "NONE" })
-- Transparent sign fold column
vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#444444", bg = "NONE" })
-- Color of word-wrap column
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#444444" })
-- Color of non-printable white spaces, with transparent background
vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#626262", bg = "NONE" })
-- Color of split window borders
vim.api.nvim_set_hl(0, "VertSplit", { fg = "#444c5e", bg = "NONE" })
vim.api.nvim_set_hl(0, "NonText", { fg = "#626262", bg = "NONE" })

-- Use italic font for comments
vim.cmd("highlight Comment cterm=italic gui=italic")

-- {{{ Colors for words that failed spell check
-- Word not recognized
vim.api.nvim_set_hl(0, "SpellBad", {})
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, fg = "#00bfff" })
-- Word not capitalized
vim.api.nvim_set_hl(0, "SpellCap", {})
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, fg = "#ff4500" })
-- Word is rare
vim.api.nvim_set_hl(0, "SpellRare", {})
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, fg = "#32cd32" })
-- Wrong spelling for selected region
vim.api.nvim_set_hl(0, "SpellLocal", {})
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, fg = "#ffb90f" })
-- }}}
