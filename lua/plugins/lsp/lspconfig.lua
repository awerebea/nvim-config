-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
  return
end

-- import nvim-navic plugin safely
local navic_setup, navic = pcall(require, "nvim-navic")
if not navic_setup then
  return
end

local keymap = vim.keymap -- for conciseness

local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "gf", "<Cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  keymap.set("n", "gd", "<Cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  keymap.set("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set("n", "<leader>ca", "<Cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  keymap.set("n", "<leader>rn", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
  end, { expr = true, noremap = true, silent = true, buffer = bufnr })
  keymap.set("n", "<leader>dl", "<Cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "<leader>dc", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  keymap.set("n", "[g", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  keymap.set("n", "]g", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  keymap.set("n", "<leader>ou", "<Cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

  -- pyright specific keymaps
  if client.name == "pyright" then
    keymap.set("n", "<leader>oi", "<Cmd>PyrightOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
  end

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "tsserver" then
    keymap.set("n", "<leader>rf", "<Cmd>TypescriptRenameFile<CR>") -- rename file and update imports
    keymap.set("n", "<leader>oi", "<Cmd>TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
    keymap.set("n", "<leader>ru", "<Cmd>TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
  end

  -- attach nvim-navic winbar
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = "??? ", Warn = "??? ", Hint = "??? ", Info = "??? " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure typescript server with plugin
typescript.setup({
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
})

-- Configure servers
local servers = {
  "bashls",
  "cssls",
  "emmet_ls",
  "gopls",
  "html",
  "pyright",
  "rust_analyzer",
  "sumneko_lua",
  "tailwindcss",
  "terraformls",
  "tflint",
  "tsserver",
}

for _, lsp in ipairs(servers) do
  local args = {
    capabilities = capabilities,
    on_attach = on_attach,
  }

  if lsp == "emmet_ls" then
    args.filetypes = {
      "css",
      "html",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "svelte",
      "typescriptreact",
    }
  elseif lsp == "sumneko_lua" then
    args.settings = { -- custom settings for lua
      Lua = {
        -- make the language server recognize "vim" global
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          -- make language server aware of runtime files
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
      },
    }
  end

  lspconfig[lsp].setup(args)
end
