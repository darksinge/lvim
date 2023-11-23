local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local mappings = {
  C = {
    name = "Typescript",
    i = { "<cmd>TypescriptAddMissingImports<Cr>", "AddMissingImports" },
    o = { "<cmd>TypescriptOrganizeImports<cr>", "OrganizeImports" },
    r = { "<cmd>TypescriptRemoveUnused<Cr>", "RemoveUnused" },
    I = { "<cmd>TypescriptOrganizeImports<cr><cmd>TypescriptRemoveUnused<cr>", "Organize and RemoveUnused" },
    R = { "<cmd>TypescriptRenameFile<Cr>", "RenameFile" },
    f = { "<cmd>TypescriptFixAll<Cr>", "FixAll" },
    g = { "<cmd>TypescriptGoToSourceDefinition<Cr>", "GoToSourceDefinition" },
  },
  ["z"] = {
    name = " console.log",
    l = { '"ayiwoconsole.log(\'<C-R>a:\', <C-R>a);<Esc>', "console.log" },
    L = { '"ayiwoconsole.log(\'<C-R>a:\', JSON.stringify(<C-R>a, null, 3));<Esc>', "console.log + JSON.stringfy" },
    e = { '"ayiwoconsole.error(\'<C-R>a:\', <C-R>a);<Esc>', "console.error" },
    E = { '"ayiwoconsole.error(\'<C-R>a:\', JSON.stringify(<C-R>a, null, 3));<Esc>',
      "console.error + JSON.stringfy" },
    d = { '"ayiwoconsole.debug(\'<C-R>a:\', <C-R>a);<Esc>', "console.debug" },
    D = { '"ayiwoconsole.debug(\'<C-R>a:\', JSON.stringify(<C-R>a, null, 3));<Esc>',
      "console.debug + JSON.stringfy" },
    i = { '"ayiwoconsole.info(\'<C-R>a:\', <C-R>a);<Esc>', "console.info" },
    I = { '"ayiwoconsole.info(\'<C-R>a:\', JSON.stringify(<C-R>a, null, 3));<Esc>', "console.info + JSON.stringfy" },
  },
}

wk.register(mappings, opts)
