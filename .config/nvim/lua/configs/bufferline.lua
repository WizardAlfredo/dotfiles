local present, bufferline = pcall(require, "bufferline")

if not present then
    return
end


local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
end

local function diagnostics_indicator(num, _, diagnostics, _)

    local result = {}
    local symbols = { error = "", warning = "", info = "" }
    for name, count in pairs(diagnostics) do
        if symbols[name] and count > 0 then
            -- table.insert(result, symbols[name] .. " " .. count)
            table.insert(result, "")
        end
    end
    result = table.concat(result, " ")
    return #result > 0 and result or ""
end

local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
        return is_ft(b, "log")
    end, buf_nums)
    if vim.tbl_isempty(logs) then
        return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr "$"
    local is_log = is_ft(buf, "log")
    if last_tab == 1 then
        return true
    end
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
end

local options = {
    on_config_done = nil,
    highlights = {
        background = {
           italic = true,
        },
        fill = {
            bg = "#1e1f21"

        },
        buffer_selected = {
            bold = true
        },
    },
    options = {
        numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both" | function
        close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
        right_mouse_command = "vert sbuffer %d", -- can be a string | function, see "Mouse actions"
        left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
        middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
        --[[ indicator_icon = "▎", ]]
        buffer_close_icon = "",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
            -- remove extension from markdown files for example
            if buf.name:match "%.md" then
                return vim.fn.fnamemodify(buf.name, ":t:r")
            end
        end,
        max_name_length = 18,
        max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
        tab_size = 18,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = diagnostics_indicator,
        -- NOTE: this will be called a lot so don't do any heavy processing here
        custom_filter = custom_filter,
        offsets = {
            {
                filetype = "undotree",
                text = "Undotree",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "NvimTree",
                text = "Explorer",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "DiffviewFiles",
                text = "Diff View",
                highlight = "PanelHeading",
                padding = 1,
            },
            {
                filetype = "flutterToolsOutline",
                text = "Flutter Outline",
                highlight = "PanelHeading",
            },
            {
                filetype = "packer",
                text = "Packer",
                highlight = "PanelHeading",
                padding = 1,
            },
        },
        show_buffer_icons = true, -- disable filetype icons for buffers
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "id",
    },
}

bufferline.setup(options)

