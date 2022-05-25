local M = {}

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

M.close_buf = function()
    if #vim.api.nvim_list_wins() == 1 then
        vim.api.nvim_command("Bdelete!")
    else
        vim.api.nvim_command("close!")
    end
end

M.save = function()
    if (#vim.api.nvim_buf_get_name(0) > 0) then
        vim.api.nvim_command("write")
        return
    end

    local input = Input({
        position = "50%",
        size = {
            width = 25,
            height = 1,
        },
        relative = "editor",
        border = {
            style = "rounded",
            text = {
                top = "Save As",
                top_align = "center",
            },
        },
        win_options = {
            winblend = 10,
            winhighlight = "Normal:Normal",
        },
    }, {
        prompt = "> ",
        default_value = "",
        on_submit = function(value)
            vim.api.nvim_command("write " .. value)
        end,
    })

    -- mount/open the component
    input:mount()

    -- unmount component when cursor leaves buffer
    input:on(event.BufLeave, function()
        input:unmount()
    end)
end


M.nui_lsp_rename = function()
    local curr_name = vim.fn.expand '<cword>'

    local params = vim.lsp.util.make_position_params()

    local function on_submit(new_name)
        if not new_name or #new_name == 0 or curr_name == new_name then
            -- do nothing if `new_name` is empty or not changed.
            return
        end

        -- add `newName` property to `params`.
        -- this is needed for making `textDocument/rename` request.
        params.newName = new_name

        -- send the `textDocument/rename` request to LSP server
        vim.lsp.buf_request(
            0,
            'textDocument/rename',
            params,
            function(_, result, _, _)
            if not result then
                -- do nothing if server returns empty result
                return
            end

            -- the `result` contains all the places we need to update the
            -- name of the identifier. so we apply those edits.
            vim.lsp.util.apply_workspace_edit(result, "utf-8")

            -- after the edits are applied, the files are not saved automatically.
            -- let's remind ourselves to save those...
            local total_files = vim.tbl_count(result.changes)
            print(
                string.format(
                    'Changed %s file%s. To save them run \':wa\'',
                    total_files,
                    total_files > 1 and 's' or ''
                )
            )
        end
        )
    end

    local popup_options = {
        -- border for the window
        border = {
            style = 'rounded',
            text = {
                top = '[Rename]',
                top_align = 'left',
            },
        },
        -- highlight for the window.
        highlight = 'Normal:Normal',
        -- place the popup window relative to the
        -- buffer position of the identifier
        relative = {
            type = 'buf',
            position = {
                -- this is the same `params` we got earlier
                row = params.position.line,
                col = params.position.character,
            },
        },
        -- position the popup window on the line below identifier
        position = {
            row = 1,
            col = 0,
        },
        size = {
            width = math.max(#curr_name + 10, 25),
            height = 1,
        },
    }

    local input = Input(popup_options, {
        -- set the default value to current name
        default_value = curr_name,
        -- pass the `on_submit` callback function we wrote earlier
        on_submit = on_submit,
        prompt = '',
    })

    input:mount()

    -- make it easier to move around long words
    local kw = vim.opt.iskeyword - '_' - '-'
    vim.bo.iskeyword = table.concat(kw:get(), ',')

    -- close on <esc> in normal mode
    input:map('n', '<esc>', input.input_props.on_close, { noremap = true })

    -- close when cursor leaves the buffer
    input:on(event.BufLeave, input.input_props.on_close, { once = true })
end

M.change_all_occurences = function(case_sensitive)
    local curr_name = vim.fn.expand '<cword>'

    local params = vim.lsp.util.make_position_params()
    local cursor_loc = vim.api.nvim_win_get_cursor(0)

    local function on_submit(new_name)
        if not new_name or #new_name == 0 or curr_name == new_name then
            -- do nothing if `new_name` is empty or not changed.
            return
        end
        if (case_sensitive) then
            vim.api.nvim_command("%s/" .. curr_name .. "/" .. new_name .. "/gI | noh")
        else

            vim.api.nvim_command("%s/" .. curr_name .. "/" .. new_name .. "/gi | noh")
        end
        vim.api.nvim_win_set_cursor(0, cursor_loc)
    end

    local popup_options = {
        -- border for the window
        border = {
            style = 'rounded',
            text = {
                top = '[Rename]',
                top_align = 'left',
            },
        },
        -- highlight for the window.
        highlight = 'Normal:Normal',
        -- place the popup window relative to the
        -- buffer position of the identifier
        relative = {
            type = 'buf',
            position = {
                -- this is the same `params` we got earlier
                row = params.position.line,
                col = params.position.character,
            },
        },
        -- position the popup window on the line below identifier
        position = {
            row = 1,
            col = 0,
        },
        size = {
            width = math.max(#curr_name + 10, 25),
            height = 1,
        },
    }

    local input = Input(popup_options, {
        -- set the default value to current name
        default_value = curr_name,
        -- pass the `on_submit` callback function we wrote earlier
        on_submit = on_submit,
        prompt = '',
    })

    input:mount()

    -- close on <esc> in normal mode
    input:map('n', '<esc>', input.input_props.on_close, { noremap = true })

    -- close when cursor leaves the buffer
    input:on(event.BufLeave, input.input_props.on_close, { once = true })
end



M.better_pasting = function()
    local _, c = unpack(vim.api.nvim_win_get_cursor(0))
    if (c ~= 0) then
        return "p"
    end
    -- xsel required
    local handle = io.popen("xsel --clipboard --output")


    if (handle == nil) then
        return
    end
    local result = handle:read("*a")

    handle:close()

    if (result:sub(-1) == '\n') then
        return "p"
    else
        return "P"
    end
end

M.toggle_bar = function(action)
    if (action == "show") then
        vim.api.nvim_command("set laststatus=2")
    else
        vim.api.nvim_command("set laststatus=0")
    end
end

return M
