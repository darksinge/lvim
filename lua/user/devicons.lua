local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
  return
end

devicons.set_icon({
  astro = {
    icon = 'Λ',
    name = 'Astro',
    color = '#ffffff',
  }
})
