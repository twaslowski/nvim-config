return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
        explorer = { hidden = true },
      },
      win = {
        -- <a-h> is tmux's pane-left binding and never reaches nvim, so hidden
        -- files toggle on <a-.> instead.
        input = {
          keys = {
            ["<a-h>"] = false,
            ["<a-.>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<a-h>"] = false,
            ["<a-.>"] = "toggle_hidden",
          },
        },
      },
    },
  },
}
