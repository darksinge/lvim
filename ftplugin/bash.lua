local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
  return
end

local vopts = lvim.builtin.which_key.vopts
local opts = lvim.builtin.which_key.opts

local mappings = {
  ["z"] = {
    name = " echo",
    l = { '"ayiwoecho "<C-R>a: $<C-R>a"<Esc>', "echo" },
    d = { '"ayiwoecho "<C-R>a: $<C-R>a" >&2<Esc>', "echo" },
  },
}


local vmappings = {
  ["z"] = {
    name = " echo",
    l = { 'yoecho "<C-R>a: $<C-R>a"<Esc>', "echo" },
    d = { 'yoecho "<C-R>a: $<C-R>a" >&2<Esc>', "echo" },
  },
}

wk.register(mappings, opts)
wk.register(vmappings, vopts)
