local ns = vim.api.nvim_create_namespace('PaperBlue')

-- новое слово
local target = '>PAPERBLUE_'

-- цвета строго по порядку
local colors = {
  '#464646',
  '#d70000',
  '#d75f00',
  '#5f8700',
  '#008700',
  '#0087af',
  '#005faf',
  '#005f87',
  '#8700af',
  '#d70087',
  '#af0000',
}

-- создаем highlight группы
for i, c in ipairs(colors) do
  vim.api.nvim_set_hl(0, 'PB' .. i, {
    fg = c,
    bold = true,
  })
end

local function highlight_word(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for lnum, line in ipairs(lines) do
    local start = 1

    while true do
      local s, e = line:find(target, start, true) -- plain search!
      if not s then
        break
      end

      for i = 0, #target - 1 do
        vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, s - 1 + i, {
          end_col = s + i,
          hl_group = 'PB' .. (i + 1),
        })
      end

      start = e + 1
    end
  end
end

vim.api.nvim_create_autocmd({
  'BufEnter',
  'TextChanged',
  'TextChangedI',
  'InsertLeave',
}, {
  callback = function(args)
    highlight_word(args.buf)
  end,
})
