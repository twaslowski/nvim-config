return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          -- marksman reports broken links/anchors as errors; drop them but keep
          -- completion, goto-definition and rename.
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- lazy.nvim concatenates list-like opts, so clearing the ft entry needs a
      -- function; LazyVim's markdown extra adds markdownlint-cli2 here.
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
}
