-- Fedpunk theme: matte-black
return {
  {
    "kxzk/matteblack.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("matteblack")
    end,
  },
}
