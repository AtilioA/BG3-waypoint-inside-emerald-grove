Config = Helpers.Config:New({
    folderName = "WaypointInsideEmeraldGrove",
    configFilePath = "waypoint_inside_emerald_grove_config.json",
    defaultConfig = {
        GENERAL = {
            enabled = true, -- Toggle the mod on/off
        },
        FEATURES = {
            new_waypoint_destination = "THE HOLLOW", -- Other options: "SACRED POOL", "ARRON"
            original_waypoint_if_sneaking = true,    -- If true, the original waypoint will be used if the player is sneaking
        },
        DEBUG = {
            level = 0 -- 0 = no debug, 1 = minimal, 2 = verbose logs
        }
    },

    acceptableThreshold = 4,
    validDestinationOptions = { "THE HOLLOW", "SACRED POOL", "ARRON" }
})

-- function Helpers.Config:ValidateParams(params)
--     assert(type(params.folderName) == "string", "folderName must be a string")
--     assert(type(params.configFilePath) == "string", "configFilePath must be a string")
--     assert(type(params.defaultConfig) == "table", "defaultConfig must be a table")
--     assert(type(params.acceptableThreshold) == "number", "acceptableThreshold must be a number")
--     assert(type(params.validDestinationOptions) == "table", "validDestinationOptions must be a table")
--     _D("Checking")
--     for _, option in ipairs(params.validDestinationOptions) do
--         assert(type(option) == "string", "All elements in validDestinationOptions must be strings")
--     end
-- end

-- ---@class HelperConfig : Helper
-- ---@field acceptableThreshold number
-- ---@field validDestinationOptions table<string>
-- Helpers.Config = _Class:Create("HelperConfig", Helper, {
--     defaultConfig "WaypointInsideEmeraldGrove", "waypoint_inside_emerald_grove_config.json",
--     {
--         GENERAL = {
--             enabled = true, -- Toggle the mod on/off
--         },
--         FEATURES = {
--             new_waypoint_destination = "THE HOLLOW", -- Options: "SACRED POOL", "ARRON"
--             original_waypoint_if_sneaking = true,    -- If true, the original waypoint will be used if the player is sneaking
--         },
--         DEBUG = {
--             level = 0 -- 0 = no debug, 1 = minimal, 2 = verbose logs
--         }
--     }
-- })

-- function Helpers.Config:UpdateConfig(existingConfig, defaultConfig)
--     -- First, call the base/original UpdateConfig method if needed.
--     -- Assuming the base method does some general configuration updates that are also required.
--     -- If the base class does not provide an UpdateConfig method or if it doesn't need to be called,
--     -- this step can be omitted or adjusted accordingly.

--     -- Custom logic for the mod
--     local updated = false -- Keep track if updates have been made

--     Helpers.Config.UpdateConfig()

--     -- for key, newValue in pairs(defaultConfig) do
--     --     local oldValue = existingConfig[key]

--     --     -- Add specific logic for the FEATURES key
--     --     if key == "FEATURES" and type(oldValue) == "table" and oldValue.new_waypoint_destination then
--     --         local closestMatch, distance = String.FindClosestMatch(oldValue.new_waypoint_destination,
--     --             self.validDestinationOptions, false)
--     --         if distance <= self.acceptableThreshold then
--     --             if oldValue.new_waypoint_destination ~= closestMatch then
--     --                 oldValue.new_waypoint_destination = closestMatch
--     --                 updated = true
--     --                 Utils.DebugPrint(1, "Corrected new_waypoint_destination to: " .. closestMatch)
--     --             end
--     --         else
--     --             Utils.DebugPrint(1, "Invalid new_waypoint_destination option. Restoring to default.")
--     --             oldValue.new_waypoint_destination = defaultConfig.FEATURES.new_waypoint_destination
--     --             updated = true
--     --         end
--     --     end

--     -- end

--     -- Return `updated` to indicate if any configuration was changed
--     return updated
-- end

Config:UpdateCurrentConfig()

-- Reload the JSON config when executing `reload_config` on SE console
-- An anonymous function is needed so that `self` is defined during the call
Ext.RegisterConsoleCommand('wieg_reload_config', function()
    Config:UpdateCurrentConfig()
    -- Update the debug level for the printer, otherwise it will remain outdated
    WIEGPrinter.DebugLevel = Config:GetCurrentDebugLevel()
    WIEGPrint(0, "Config reloaded: " .. Ext.Json.Stringify(Config:cfg(), { Beautify = true }))
end)
