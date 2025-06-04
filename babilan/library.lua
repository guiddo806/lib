local config_manager = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ensure the config folder exists
if not isfolder("viteck/configs/") then
    makefolder("viteck/configs/")
end

-- Function to serialize table to Lua string
local function serialize_table(tbl, indent)
    indent = indent or 0
    local str = "{\n"
    local indent_str = string.rep("    ", indent + 1)
    
    for key, value in pairs(tbl) do
        local key_str = type(key) == "string" and string.format("%q", key) or tostring(key)
        if type(value) == "table" then
            str = str .. indent_str .. "[" .. key_str .. "] = " .. serialize_table(value, indent + 1) .. ",\n"
        elseif type(value) == "string" then
            str = str .. indent_str .. "[" .. key_str .. "] = " .. string.format("%q", value) .. ",\n"
        elseif type(value) == "boolean" or type(value) == "number" then
            str = str .. indent_str .. "[" .. key_str .. "] = " .. tostring(value) .. ",\n"
        elseif value == nil then
            str = str .. indent_str .. "[" .. key_str .. "] = nil,\n"
        end
    end
    
    return str .. string.rep("    ", indent) .. "}"
end

-- Function to save configuration
function config_manager:save_config(library, config_name)
    local config = {}
    
    -- Iterate through all flags in the library
    for flag, value in pairs(library.flags) do
        if type(value) == "table" then
            -- Handle Colorpicker (RGBA)
            if value.r and value.g and value.b and value.transparency then
                config[flag] = {
                    type = "color",
                    r = value.r,
                    g = value.g,
                    b = value.b,
                    transparency = value.transparency
                }
            -- Handle Keybind
            elseif #value == 3 and value[1] and value[2] and type(value[3]) == "boolean" then
                config[flag] = {
                    type = "keybind",
                    key = tostring(value[1]):gsub("Enum%.", ""),
                    mode = value[2],
                    toggled = value[3]
                }
            -- Handle Multi Dropdown
            elseif type(value) == "table" and #value > 0 then
                config[flag] = {
                    type = "dropdown",
                    multi = true,
                    value = value
                }
            end
        -- Handle Single Dropdown
        elseif type(value) == "string" then
            config[flag] = {
                type = "dropdown",
                multi = false,
                value = value
            }
        -- Handle Toggle
        elseif type(value) == "boolean" then
            config[flag] = {
                type = "toggle",
                value = value
            }
        -- Handle Slider or Textbox
        elseif type(value) == "number" or type(value) == "string" then
            config[flag] = {
                type = type(value) == "number" and "slider" or "textbox",
                value = value
            }
        -- Handle Label (if flagged)
        elseif type(value) == "string" then
            config[flag] = {
                type = "label",
                value = value
            }
        end
    end
    
    -- Write configuration to file in Lua format
    local success, error = pcall(function()
        local lua_content = "return " .. serialize_table(config)
        writefile("viteck/configs/" .. config_name .. ".lua", lua_content)
    end)
    
    if success then
        library:notification({
            message = "Configuration '" .. config_name .. "' saved successfully!",
            duration = 3,
            color = library.accent
        })
    else
        warn("Failed to save configuration:", error)
        library:notification({
            message = "Failed to save configuration: " .. tostring(error),
            duration = 5,
            color = Color3.fromRGB(255, 0, 0)
        })
    end
end

-- Function to load configuration
function config_manager:load_config(library, config_name)
    if isfile("viteck/configs/" .. config_name .. ".lua") then
        local success, config = pcall(function()
            return loadstring(readfile("viteck/configs/" .. config_name .. ".lua"))()
        end)
        
        if success then
            for flag, data in pairs(config) do
                if library.flags[flag] then
                    if data.type == "toggle" then
                        library.flags[flag] = data.value
                        if flags[flag] then
                            flags[flag](data.value)
                        end
                    elseif data.type == "slider" or data.type == "textbox" then
                        library.flags[flag] = data.value
                        if flags[flag] then
                            flags[flag](data.value)
                        end
                    elseif data.type == "dropdown" then
                        library.flags[flag] = data.value
                        if flags[flag] then
                            if data.multi then
                                flags[flag](data.value)
                            else
                                flags[flag]:Set(data.value)
                            end
                        end
                    elseif data.type == "color" then
                        library.flags[flag] = library:RGBA(data.r * 255, data.g * 255, data.b * 255, data.transparency)
                        if flags[flag] then
                            flags[flag](Color3.fromRGB(data.r * 255, data.g * 255, data.b * 255), data.transparency)
                        end
                    elseif data.type == "keybind" then
                        local key = Enum
                        for _, part in ipairs(data.key:split(".")) do
                            key = key[part]
                        end
                        library.flags[flag] = { key, data.mode, data.toggled }
                        if flags[flag] then
                            flags[flag](key)
                            if data.mode then
                                local keybind = flags[flag]
                                if type(keybind) == "table" and keybind.SetMode then
                                    keybind:SetMode(data.mode)
                                end
                            end
                        end
                    elseif data.type == "label" then
                        library.flags[flag] = data.value
                        if flags[flag] then
                            flags[flag](data.value)
                        end
                    end
                end
            end
            library:notification({
                message = "Configuration '" .. config_name .. "' loaded successfully!",
                duration = 3,
                color = library.accent
            })
        else
            warn("Failed to load configuration:", config)
            library:notification({
                message = "Failed to load configuration: " .. tostring(config),
                duration = 5,
                color = Color3.fromRGB(255, 0, 0)
            })
        end
    else
        library:notification({
            message = "Configuration '" .. config_name .. "' does not exist!",
            duration = 5,
            color = Color3.fromRGB(255, 0, 0)
        })
    end
end

-- Function to delete configuration
function config_manager:delete_config(library, config_name)
    if isfile("viteck/configs/" .. config_name .. ".lua") then
        local success, error = pcall(function()
            delfile("viteck/configs/" .. config_name .. ".lua")
        end)
        
        if success then
            library:notification({
                message = "Configuration '" .. config_name .. "' deleted successfully!",
                duration = 3,
                color = library.accent
            })
        else
            warn("Failed to delete configuration:", error)
            library:notification({
                message = "Failed to delete configuration: " .. tostring(error),
                duration = 5,
                color = Color3.fromRGB(255, 0, 0)
            })
        end
    else
        library:notification({
            message = "Configuration '" .. config_name .. "' does not exist!",
            duration = 5,
            color = Color3.fromRGB(255, 0, 0)
        })
    end
end

-- Function to get list of configurations
function config_manager:get_configs()
    local configs = {}
    if isfolder("viteck/configs/") then
        for _, file in pairs(listfiles("viteck/configs/")) do
            local name = file:match("viteck/configs/(.+)%.lua$")
            if name then
                table.insert(configs, name)
            end
        end
    end
    -- Debug: Print the list of configs
    print("Configs found:", table.concat(configs, ", "))
    return configs
end

-- Function to build the configuration UI
function config_manager:build_configs(library, section)
    -- Config name input
    local config_name = section:Textbox({
        Name = "Configzz Name",
        Placeholder = "Enter config name",
        State = "",
        Flag = "config_name"
    })

    -- Config list dropdown
    local config_list
    config_list = section:dropdown({
        Name = "Config List",
        Options = self:get_configs(),
        Flag = "config_list",
        Default = nil
    })

    -- Save button
    section:button({
        Name = "Save Config",
        Callback = function()
            local name = library.flags["config_name"]
            if name and name ~= "" then
                self:save_config(library, name)
                -- Small delay to ensure file is written
                wait(0.1)
                local new_configs = self:get_configs()
                -- Try refreshing the dropdown
                if config_list.Refresh then
                    config_list:Refresh(new_configs)
                    print("Dropdown refreshed with:", table.concat(new_configs, ", "))
                else
                    -- Fallback: Recreate dropdown if Refresh doesn't work
                    config_list:Destroy() -- Assuming Destroy method exists
                    config_list = section:dropdown({
                        Name = "Config List",
                        Options = new_configs,
                        Flag = "config_list",
                        Default = nil
                    })
                    print("Dropdown recreated with:", table.concat(new_configs, ", "))
                end
            else
                library:notification({
                    message = "Please enter a valid config name!",
                    duration = 5,
                    color = Color3.fromRGB(255, 0, 0)
                })
            end
        end
    })

    -- Load button
    section:button({
        Name = "Load Config",
        Callback = function()
            local name = library.flags["config_list"]
            if name then
                self:load_config(library, name)
            else
                library:notification({
                    message = "Please select a config to load!",
                    duration = 5,
                    color = Color3.fromRGB(255, 0, 0)
                })
            end
        end
    })

    -- Delete button
    section:button({
        Name = "Delete Config",
        Callback = function()
            local name = library.flags["config_list"]
            if name then
                self:delete_config(library, name)
                -- Small delay to ensure file is deleted
                wait(0.1)
                local new_configs = self:get_configs()
                -- Try refreshing the dropdown
                if config_list.Refresh then
                    config_list:Refresh(new_configs)
                    print("Dropdown refreshed with:", table.concat(new_configs, ", "))
                else
                    -- Fallback: Recreate dropdown
                    config_list:Destroy()
                    config_list = section:dropdown({
                        Name = "Config List",
                        Options = new_configs,
                        Flag = "config_list",
                        Default = nil
                    })
                    print("Dropdown recreated with:", table.concat(new_configs, ", "))
                end
            else
                library:notification({
                    message = "Please select a config to delete!",
                    duration = 5,
                    color = Color3.fromRGB(255, 0, 0)
                })
            end
        end
    })

    -- Initial refresh for safety
    wait(0.1)
    if config_list.Refresh then
        config_list:Refresh(self:get_configs())
    end
end

return config_manager
