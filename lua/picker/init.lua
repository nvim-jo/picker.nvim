local builtin_picker = require('telescope.builtin')
local extensions_picker = require('telescope._extensions')

local results = {}

local opts_picker = {
    bufnr = vim.api.nvim_get_current_buf(),
    winnr = vim.api.nvim_get_current_win(),
}

local picker = extensions_picker._config.picker or {}
local excluded = picker.excluded_pickers or {}
local plugin_opts = picker.opts or {}
local funcs = picker.actions or {}
local user_pickers = picker.user_pickers or {}

for _, v in ipairs(user_pickers) do
    results[v[1]] = {
        action = v[2],
    }
end

for name, item in pairs(builtin_picker) do
    if not (vim.tbl_contains(excluded, name)) then
        results[name] = {
            action = funcs[name] or item or function() end,
            opt = plugin_opts[name] or opts_picker,
        }
    end
end

for extension, item in pairs(extensions_picker.manager) do
    if not (vim.tbl_contains(excluded, extension)) then
        for name, action in pairs(item) do
            local key = extension
            if name ~= extension and vim.tbl_count(item) > 1 then
                key = key .. ": " .. name
            end
            results[key] = {
                action = action,
                opt = plugin_opts[extension] or opts_picker,
            }
        end
    end
end

return { results = results }
