local M = {}

M.general = {
  n = {
    ["<C-h"] = { "<cmd> TmuxNavigateLeft<Cr>", "window left"},
    ["<C-l"] = { "<cmd> TmuxNavigateRight<Cr>", "window right"},
    ["<C-j"] = { "<cmd> TmuxNavigateDown<Cr>", "window down"},
    ["<C-k"] = { "<cmd> TmuxNavigateUp<Cr>", "window up"},
  }
}
M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
      "<cmd> DapToggleBreakpoint <CR>",
      "Add breakpoint at line"
    },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.dap_go = {
  plugin = true,
  n = {
    ["<leader>dgt"] = {
      function()
        require('dap-go').debug_test()
      end,
      "Debug go test"
    },
    ["<leader>dgl"] = {
      function()
        require('dap-go').debug_last()
      end,
      "Debug last go test"
    }
  }
}

M.gopher = {
  plugin = true,
  n = {
    ["<leader>gsj"] = {
      "<cmd> GoTagAdd json <CR>",
      "Add json struct tags"
    },
    ["<leader>gsy"] = {
      "<cmd> GoTagAdd yaml <CR>",
      "Add yaml struct tags"
    }
  }
}


M.diagnostics = {
  n = {
    -- show error
    -- do cmd twice to go into diagnostic buffer
    -- do ctr + h, ... to leave buffer 
    ["<leader>ds"] = {
      "<cmd>lua vim.diagnostic.open_float()<CR>",
      "Show and copy diagnostics"
    }
  }
}

-- Copilot mapping
M.copilot = {
  plugin = true,
  i = {
    ["<C-f>"] = {
      'copilot#Accept("\\<CR>")',
      { expr = true, replace_keycodes = false },
      "Accept Copilot suggestion"
    }
  }
}
return M
