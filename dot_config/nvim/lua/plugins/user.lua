--if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  "andweeb/presence.nvim",
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require("lsp_signature").setup() end,
  },
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>fz"] = { function() require("snacks").picker.zoxide() end, desc = "Find projects with zoxide" }

      opts.options.opt.relativenumber = false
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    opts = {
      handlers = {
        gitsigns = true,
      },
    },
  },
}
