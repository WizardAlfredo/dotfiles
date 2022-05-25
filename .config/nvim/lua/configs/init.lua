local active_plugins = require('global_configs').active_plugins

for _, v in pairs(active_plugins) do
    pcall(require, "configs." .. v)
end
