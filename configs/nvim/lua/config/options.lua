-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.cmd.language("time C")

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.langmap =
  "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"
vim.opt.spelllang = "en_us,ru_ru"
vim.opt.spell = true

-- TODO: изменить на относительный путь от CWD или PWD
-- Команда для копирования пути к файлу и строки в буфер обмена
vim.api.nvim_create_user_command("CopyPathWithLine", function()
  local file_path = vim.fn.expand("%:.") -- Абсолютный путь к файлу
  local line_number = vim.fn.line(".") -- Номер текущей строки
  local result = file_path .. ":" .. line_number

  -- Сохранение в системный буфер обмена
  vim.fn.setreg("+", result)
end, {})
