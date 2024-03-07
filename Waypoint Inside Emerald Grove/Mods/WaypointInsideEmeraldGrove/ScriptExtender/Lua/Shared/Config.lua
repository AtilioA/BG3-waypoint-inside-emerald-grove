Config = {}

FolderName = "WaypointInsideEmeraldGrove"
Config.configFilePath = "waypoint_inside_emerald_grove_config.json"

Config.defaultConfig = {
    GENERAL = {
        enabled = true, -- Toggle the mod on/off
    },
    FEATURES = {
        new_waypoint_destination = "THE HOLLOW", -- Options: "SACRED POOL", "ARRON"
        original_waypoint_if_sneaking = true,    -- If true, the original waypoint will be used if the player is sneaking
    },
    DEBUG = {
        level = 0 -- 0 = no debug, 1 = minimal, 2 = verbose logs
    }
}

Config.acceptableThreshold = 4
Config.validDestinationOptions = { "THE HOLLOW", "SACRED POOL", "ARRON" }


function Config.GetModPath(filePath)
    return FolderName .. '/' .. filePath
end

-- Load a JSON configuration file and return a table or nil
function Config.LoadConfig(filePath)
    local configFileContent = Ext.IO.LoadFile(Config.GetModPath(filePath))
    if configFileContent and configFileContent ~= "" then
        Utils.DebugPrint(1, "Loaded config file: " .. filePath)
        return Ext.Json.Parse(configFileContent)
    else
        Utils.DebugPrint(1, "File not found: " .. filePath)
        return nil
    end
end

-- Save a config table to a JSON file
function Config.SaveConfig(filePath, config)
    local configFileContent = Ext.Json.Stringify(config, { Beautify = true })
    Ext.IO.SaveFile(Config.GetModPath(filePath), configFileContent)
end

function Config.UpdateConfig(existingConfig, defaultConfig)
    local updated = false

    for key, newValue in pairs(defaultConfig) do
        local oldValue = existingConfig[key]

        if key == "FEATURES" and type(oldValue) == "table" and oldValue.new_waypoint_destination then
            local closestMatch, distance = String.FindClosestMatch(oldValue.new_waypoint_destination,
                Config.validDestinationOptions, false)
            if distance <= Config.acceptableThreshold then
                if oldValue.new_waypoint_destination ~= closestMatch then
                    oldValue.new_waypoint_destination = closestMatch
                    updated = true
                    Utils.DebugPrint(1, "Corrected new_waypoint_destination to:" .. closestMatch)
                end
            else
                Utils.DebugPrint(1, "Invalid new_waypoint_destination option. Restoring to default.")
                oldValue.new_waypoint_destination = defaultConfig.FEATURES.new_waypoint_destination
                updated = true
            end
        end

        if oldValue == nil then
            -- Add missing keys from the default config
            existingConfig[key] = newValue
            updated = true
            Utils.DebugPrint(1, "Added new config option:", key)
        elseif type(oldValue) ~= type(newValue) then
            -- If the type has changed...
            if type(newValue) == "table" then
                -- ...and the new type is a table, place the old value in the 'enabled' key
                existingConfig[key] = { enabled = oldValue }
                for subKey, subValue in pairs(newValue) do
                    if existingConfig[key][subKey] == nil then
                        existingConfig[key][subKey] = subValue
                    end
                end
                updated = true
                Utils.DebugPrint(1, "Updated config structure for:", key)
            else
                -- ...otherwise, just replace with the new value
                existingConfig[key] = newValue
                updated = true
                Utils.DebugPrint(1, "Updated config value for:", key)
            end
        elseif type(newValue) == "table" then
            -- Recursively update for nested tables
            if Config.UpdateConfig(oldValue, newValue) then
                updated = true
            end
        end
    end

    -- Remove deprecated keys
    for key, _ in pairs(existingConfig) do
        if defaultConfig[key] == nil then
            -- Remove keys that are not in the default config
            existingConfig[key] = nil
            updated = true
            Utils.DebugPrint(1, "Removed deprecated config option:", key)
        end
    end

    return updated
end

function Config.LoadJSONConfig()
    local jsonConfig = Config.LoadConfig(Config.configFilePath)
    if not jsonConfig then
        jsonConfig = Config.defaultConfig
        Config.SaveConfig(Config.configFilePath, jsonConfig)
        Utils.DebugPrint(1, "Default config file loaded.")
    else
        if Config.UpdateConfig(jsonConfig, Config.defaultConfig) then
            Config.SaveConfig(Config.configFilePath, jsonConfig)
            Utils.DebugPrint(1, "Config file updated with new options.")
        else
            Utils.DebugPrint(1, "Config file loaded.")
        end
    end

    return jsonConfig
end

JsonConfig = Config.LoadJSONConfig()

return Config
