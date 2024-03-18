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
    onConfigReloaded = {},
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
            local closestMatch, distance = Helpers.String:FindClosestMatch(oldValue.new_waypoint_destination,
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

Config:AddConfigReloadedCallback(function(configInstance)
    WIEGPrinter.DebugLevel = configInstance:GetCurrentDebugLevel()
    WIEGPrint(0, "Config reloaded: " .. Ext.Json.Stringify(configInstance:getCfg(), { Beautify = true }))
end)
Config:RegisterReloadConfigCommand("wieg")
