local gitlab_ci = "https://gitlab.com/gitlab-org/gitlab-foss/-/raw/master/app/assets/javascripts/editor/schema/ci.json"

-- Kubernetes manifests have no naming convention, so they're matched by the
-- directories they live in. "kubernetes" is a yamlls keyword: it resolves to the
-- kubernetes-json-schema bundle and picks the schema per apiVersion/kind.
local k8s_dirs = { "apps", "autoscaler", "post-infrastructure", "infrastructure" }

local function k8s_patterns()
  local patterns = {}
  for _, dir in ipairs(k8s_dirs) do
    table.insert(patterns, dir .. "/**/*.yaml")
    table.insert(patterns, dir .. "/**/*.yml")
  end
  return patterns
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          -- Replaces (not extends) the LazyVim yaml extra's before_init: it
          -- force-merges the catalog over settings.yaml.schemas, which would
          -- drop any fileMatch patterns added under a catalog URL key.
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas(),
              {
                [gitlab_ci] = {
                  ".gitlab-ci.yml",
                  ".gitlab-ci.yaml",
                  "**/*.gitlab-ci.yml",
                  "**/*.gitlab-ci.yaml",
                  -- local `include:` fragments, which the catalog misses
                  "**/.gitlab/ci/**/*.yml",
                  "**/.gitlab/ci/**/*.yaml",
                },
                kubernetes = k8s_patterns(),
              }
            )
          end,
        },
      },
    },
  },
}
