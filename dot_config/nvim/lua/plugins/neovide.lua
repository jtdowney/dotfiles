if not vim.g.neovide then
  return {} -- do nothing if not in a Neovide session
end

return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    mappings = {
      n = {
        ["<D-s>"] = { ":w!<cr>", desc = "Save File" },
        ["<D-v>"] = { '"+P', desc = "Paste from clipboard" },
      },
      v = {
        ["<D-c>"] = { '"+y', desc = "Copy to clipboard" },
        ["<D-v>"] = { '"+P', desc = "Paste from clipboard" },
      },
      c = {
        ["<D-v>"] = { "<C-R>+", desc = "Paste from clipboard" },
      },
      i = {
        ["<D-v>"] = { '<ESC>l"+Pli', desc = "Paste from clipboard" },
      },
    },
  },
}
