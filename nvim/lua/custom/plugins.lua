
local on_attach = require("plugins.configs.lspconfig").on_attach
local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "csharpier",
        "csharp-language-server",
        "clangd",
        "clang-format",
        "codelldb",
        "pyright",
        "ruff-lsp",
        "black",
        "github/copilot.vim",
        "templ",
        "tailwindcss",
        "sql-formatter",
        "sqlfluff",
        "sqlfmt",
        "sqls",
      },
    },
  },
  {
    "github/copilot.vim",
     event = "VeryLazy",
    config = function()
      -- Set Copilot keymap to use <C-F> instead of <Tab>
      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false
      })
      vim.g.copilot_no_tab_map = true
  end,

  },
  -- NVIM DAP SETTINGS
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").load_mappings("dap")
    end,
  },
  {
    "dreamsofcode-io/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function(_, opts)
      require("dap-go").setup(opts)
      require("core.utils").load_mappings("dap_go")
    end
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {}
    },
  },

  -- LS Settings
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    --ft = "go",
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
      require("core.utils").load_mappings("gopher")
    end,
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
  {
    "theprimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      { "<leader>A", function() require("harpoon"):list():add() end, desc = "add file to harpoon", },
      { "<leader>a", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "harpoon menu", },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = " harpoon to File 1", },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = " harpoon to File 2", },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = " harpoon to File 3", },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = " harpoon to File 4", },
      { "<leader>5", function() require("harpoon"):list():select(5) end, desc = " harpoon to File 5", },
    },
  },
  {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "scala", "sbt", "java" },
  opts = function()
    local metals_config = require("metals").bare_config()
    metals_config.on_attach = on_attach

    return metals_config
  end,
  config = function(self, metals_config)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = self.ft,
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end
  },
  {
    "tpope/vim-dadbod",
    event = "VimEnter",
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    event = "VimEnter",
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    event = "VimEnter",
  }
}
return plugins
