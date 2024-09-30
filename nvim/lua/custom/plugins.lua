local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "clangd",
        "clang-format",
        "codelldb",
        "pyright",--python
        "ruff-lsp",
        "black",
        "github/copilot.vim",
        "templ",
        "tailwindcss"
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
    end
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
}
return plugins
