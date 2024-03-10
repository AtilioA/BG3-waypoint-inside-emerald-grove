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

function Helpers.Config:UpdateModConfig(updateFile)
    local updated = false

    Config:UpdateCurrentConfig()

    -- Custom logic for THIS mod
    for key, newValue in pairs(self.defaultConfig) do
        local oldValue = self.currentConfig[key]

        -- Specific logic for treating the FEATURES key, using levenshtein distance to correct typos
        if key == "FEATURES" and type(oldValue) == "table" and oldValue.new_waypoint_destination then
            local closestMatch, distance = String:FindClosestMatch(oldValue.new_waypoint_destination,
                self.validDestinationOptions, false)
            if distance <= self.acceptableThreshold then
                if oldValue.new_waypoint_destination ~= closestMatch then
                    self.currentConfig.FEATURES.new_waypoint_destination = closestMatch
                    updated = true
                    _P("Corrected new_waypoint_destination to: " .. closestMatch)
                end
            else
                _P("Invalid new_waypoint_destination option. Restoring to default.")
                self.currentConfig.FEATURES.new_waypoint_destination = self.defaultConfig.FEATURES
                    .new_waypoint_destination
                updated = true
            end
        end
    end

    if updateFile then
        self:SaveCurrentConfig()
    end

    return updated
end

Config:UpdateModConfig(true)

-- Reload the JSON config when executing `reload_config` on SE console
-- An anonymous function is needed so that `self` is defined during the call
Ext.RegisterConsoleCommand('wieg_reload_config', function()
    Config:UpdateModConfig()
    -- Update the debug level for the printer, otherwise it will remain outdated
    WIEGPrinter.DebugLevel = Config:GetCurrentDebugLevel()
    WIEGPrint(0, "Config reloaded: " .. Ext.Json.Stringify(Config:getCfg(), { Beautify = true }))
end)
