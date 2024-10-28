-- general
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n','<s-g>','<s-g>zz')
vim.keymap.set('n', 'gd', function()
    vim.cmd('normal! gdzz')
end)

--#region Scala worksheet
-- Variable zum Tracken des Worksheet Buffer Status
local worksheet_buffer = nil

-- Funktion zum Öffnen/Schließen des Worksheet Outputs
local function toggle_worksheet()
    if worksheet_buffer and vim.api.nvim_buf_is_valid(worksheet_buffer) then
        -- Wenn der Buffer existiert, gehe zurück zum vorherigen Buffer
        vim.cmd('buffer #')
        worksheet_buffer = nil
    else
        -- Kopiere den Worksheet Output und warte auf Beendigung
        vim.cmd('MetalsCopyWorksheetOutput')
        -- Kurze Verzögerung um sicherzustellen, dass der Output verfügbar ist
        vim.defer_fn(function()
            -- Erstelle einen neuen Buffer
            worksheet_buffer = vim.api.nvim_create_buf(false, true)
            -- Hole den kopierten Text aus der System-Zwischenablage
            local clipboard = vim.fn.getreg('+')
            -- Prüfe ob wir Inhalt haben
            if clipboard and clipboard ~= '' then
                -- Setze den Inhalt des neuen Buffers
                vim.api.nvim_buf_set_lines(worksheet_buffer, 0, -1, false, vim.split(clipboard, '\n'))
                -- Wechsle zum neuen Buffer im aktuellen Fenster
                vim.api.nvim_set_current_buf(worksheet_buffer)
                -- Setze Buffer Optionen
                vim.bo[worksheet_buffer].modifiable = false
                vim.bo[worksheet_buffer].buftype = 'nofile'
                vim.bo[worksheet_buffer].swapfile = false
                vim.bo[worksheet_buffer].bufhidden = 'wipe'
                -- Setze den Dateinamen für den Buffer
                vim.api.nvim_buf_set_name(worksheet_buffer, 'worksheet.sc')
                -- Setze Scala Worksheet Filetype und Syntax (neue Methode)
                vim.bo[worksheet_buffer].filetype = 'scala'
                vim.cmd([[
                    augroup WorksheetHighlight
                        autocmd! * <buffer>
                        autocmd BufEnter <buffer> set syntax=scala
                        autocmd BufEnter <buffer> set ft=scala
                    augroup END
                ]])
                -- Trigger Syntax Highlighting neu
                vim.cmd('syntax enable')
                vim.cmd('syntax sync fromstart')
            else
                -- Falls kein Inhalt verfügbar ist
                vim.notify("Kein Worksheet Output verfügbar", vim.log.levels.WARN)
                worksheet_buffer = nil
            end
        end, 100) -- 100ms Verzögerung
    end
end

-- Setze den Keymap
vim.keymap.set('n', '<leader>ws', toggle_worksheet, { noremap = true, silent = true })
