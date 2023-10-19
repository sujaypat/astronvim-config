return {
  -- Configure AstroNvim updates
  updater = {
    remote = "origin", -- remote to use
    channel = "stable", -- "stable" or "nightly"
    version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    branch = "nightly", -- branch name (NIGHTLY ONLY)
    commit = nil, -- commit hash (NIGHTLY ONLY)
    pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts = false, -- skip prompts about breaking changes
    show_changelog = true, -- show the changelog after performing an update
    auto_quit = false, -- automatically quit the current session after a successful update
    remotes = { -- easily add new remotes to track
      --   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
      --   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
      --   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
    },
  },

  -- Set colorscheme to use
  colorscheme = "astrodark",

  -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
  diagnostics = {
    virtual_text = true,
    underline = true,
  },

  lsp = {
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = true, -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        -- "lua_ls",
      },
      timeout_ms = 1000, -- default format timeout
      -- filter = function(client) -- fully override the default formatting function
      --   return true
      -- end
    },
    -- enable servers that you already have installed without mason
    servers = {
      -- "pyright"
    },
  },

  -- Configure require("lazy").setup() options
  lazy = {
    defaults = { lazy = true },
    performance = {
      rtp = {
        -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
      },
    },
  },

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    -- Set up custom filetypes
    -- vim.filetype.add {
    --   extension = {
    --     foo = "fooscript",
    --   },
    --   filename = {
    --     ["Foofile"] = "fooscript",
    --   },
    --   pattern = {
    --     ["~/%.config/foo/.*"] = "fooscript",
    --   },
    -- }
    local map = vim.keymap.set
    local set = vim.opt

    -- Set options
    set.relativenumber = false

    -- Set key bindings
    map("n", "<C-J>", "<C-W><C-J>", {noremap = true, silent = false})
    map("n", "<C-K>", "<C-W><C-K>", {noremap = true, silent = false})
    map("n", "<C-L>", "<C-W><C-L>", {noremap = true, silent = false})
    map("n", "<C-H>", "<C-W><C-H>", {noremap = true, silent = false})

    map("c", "W<CR>", "w<CR>", {noremap = false, silent = false})
    map("c", "Wq<CR>", "wq<CR>", {noremap = false, silent = false})
    map("c", "Q<CR>", "q<CR>", {noremap = false, silent = false})
    map("c", "Qa<CR>", "qa<CR>", {noremap = false, silent = false})

    map("c", "w!!", "w !sudo tee % > /dev/null", {noremap = false, silent = false})

    map("n", "Q", "<op>", {noremap = true, silent = false})
    map("n", "<C-G>", ":noh<return><esc>", {noremap = true, silent = false})

    -- Set autocommands
    vim.api.nvim_create_augroup("packer_conf", {})
    vim.api.nvim_create_autocmd("VimEnter", {
      desc = "vim entry commands",
      group = "packer_conf",
      pattern = "*",
      command = "Neotree",
    })
    vim.api.nvim_create_autocmd("Filetype", {
      desc = "set python formatting",
      group = "packer_conf",
      pattern = "python",
      command = "setl et ts=4 sw=4"
    })
    vim.api.nvim_create_autocmd("Filetype", {
      desc = "set shellscript formatting",
      group = "packer_conf",
      pattern = "sh",
      command = "setl et ts=2 sw=2"
    })
    vim.api.nvim_create_autocmd("Filetype", {
      desc = "set config file formatting",
      group = "packer_conf",
      pattern = "{coffee,groovy,elm,dockerfile}",
      command = "setl textwidth=80 softtabstop=2 shiftwidth=2 tabstop=2 expandtab colorcolumn=80"
    })
    vim.api.nvim_create_autocmd("Filetype", {
      desc = "set make formatting",
      group = "packer_conf",
      pattern = "make",
      command = "setl et"
    })

    vim.api.nvim_create_autocmd("BufReadPost", {
      desc = "Sync packer after modifying plugins.lua",
      group = "packer_conf",
      pattern = "*.cuh",
      command = "set filetype=c",
    })
  end,
}
