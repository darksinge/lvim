local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local vopts = lvim.builtin.which_key.vopts
local opts = lvim.builtin.which_key.opts

local icons = {
  debug = '',
  debug_console = '',
  telescope = '',
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
  ["t"] = {
    name = icons.telescope .. 'Typescript Utils',
    -- t = { ':Vitest run<cr>', icons.debug .. ' Vitest Run' },
    -- w = { ':Vitest run<cr>', icons.telescope .. ' Vitest Watch' },
    -- p = { ':Vitest run<cr>', ' Typecheck Project' },
    t = { ":lua require'neotest'.run.run()<cr>", icons.debug .. ' Vitest Run' },
    w = { ":lua require'neotest'.watch.watch()<cr>", icons.debug .. ' Vitest Watch' },
    c = { ':TSTypecheck<cr>', lvim.icons.diagnostics.Trace .. ' Run Typechecking' },
    f = { ':FindTestFile<cr>', lvim.icons.ui.FindFile .. ' Find Test File For Buffer' }
  },
}


local vmappings = {
  ["z"] = {
    name = " console.log",
    l = { 'yoconsole.log(\'<esc>pa:\', <esc>pa);<Esc>', "console.log" },
    L = { 'yoconsole.log(\'<esc>pa:\', JSON.stringify(<esc>pa, null, 3));<Esc>', "console.log + JSON.stringfy" },
    e = { 'yoconsole.error(\'<esc>pa:\', <esc>pa);<Esc>', "console.error" },
    E = { 'yoconsole.error(\'<esc>pa:\', JSON.stringify(<esc>pa, null, 3));<Esc>',
      "console.error + JSON.stringfy" },
    d = { 'yoconsole.debug(\'<esc>pa:\', <esc>pa);<Esc>', "console.debug" },
    D = { 'yoconsole.debug(\'<esc>pa:\', JSON.stringify(<esc>pa, null, 3));<Esc>',
      "console.debug + JSON.stringfy" },
    i = { 'yoconsole.info(\'<esc>pa:\', <esc>pa);<Esc>', "console.info" },
    I = { 'yoconsole.info(\'<esc>pa:\', JSON.stringify(<esc>pa, null, 3));<Esc>', "console.info + JSON.stringfy" },
  },
}

wk.register(mappings, opts)
wk.register(vmappings, vopts)
