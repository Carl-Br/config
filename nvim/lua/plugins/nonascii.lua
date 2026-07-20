local ns_diag = vim.api.nvim_create_namespace 'nonascii_diag'
local ns_hl = vim.api.nvim_create_namespace 'nonascii_hl'

local allowed = {}
for _, c in ipairs { 'ä', 'ö', 'ü', 'ß', '€' } do
  allowed[c] = true
  allowed[vim.fn.toupper(c)] = true
end

local ft_ok = {
  go = true,
  lua = true,
  json = true,
  javascript = true,
  typescript = true,
  typescriptreact = true,
}

vim.api.nvim_set_hl(0, 'NonAsciiChar', { bg = '#7a1f1f', fg = '#ffffff' })

local function check(buf)
  local diags = {}
  vim.api.nvim_buf_clear_namespace(buf, ns_hl, 0, -1)

  for lnum, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    for col, char in line:gmatch '()([\xc2-\xf4][\x80-\xbf]*)' do
      if not allowed[char] then
        vim.api.nvim_buf_set_extmark(buf, ns_hl, lnum - 1, col - 1, {
          end_col = col - 1 + #char,
          hl_group = 'NonAsciiChar',
        })
        table.insert(diags, {
          lnum = lnum - 1,
          col = col - 1,
          end_col = col - 1 + #char,
          severity = vim.diagnostic.severity.WARN,
          source = 'nonascii',
          message = string.format('Nicht-ASCII-Zeichen %q (U+%04X)', char, vim.fn.char2nr(char)),
        })
      end
    end
  end

  vim.diagnostic.set(ns_diag, buf, diags)
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'InsertLeave', 'TextChanged' }, {
  group = vim.api.nvim_create_augroup('nonascii', { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype == '' and ft_ok[vim.bo[args.buf].filetype] then
      check(args.buf)
    end
  end,
})
