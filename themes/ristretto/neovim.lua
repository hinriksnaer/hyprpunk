-- Fedpunk theme: ristretto
return {
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd.colorscheme("monokai-pro")
    end,
  },
}
