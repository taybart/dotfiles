return {
  go = {
    cmd = {"gopls", "serve"},
    settings = {
      gopls = {
        buildFlags =  {"-tags=kyc,enrollment,oprah"},
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  typescript = {},
  tailwindcss = {
    filetypes = {
      "aspnetcorerazor", "blade", "django-html", "edge", "eelixir", "ejs",
      "erb", "eruby", "gohtml", "haml", "handlebars", "hbs", "html",
      "html-eex", "jade", "leaf", "liquid", "mdx", "mustache", "njk",
      "nunjucks", "php", "razor", "slim", "twig", "css", "less",
      "postcss", "sass", "scss", "stylus", "sugarss", "javascript",
      "javascriptreact", "reason", "rescript", "typescript",
      "typescriptreact", "vue", "svelte"
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            "[\\w]*[cC]lass[\\w]*\\s*[:=]\\s*[{\"'`]+(.*)[\"'`}]+"
          }
        }
      }
    }
  },
  lua = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
  },
}
