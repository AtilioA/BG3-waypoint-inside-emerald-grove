SubscribedEvents = {}

function SubscribedEvents.SubscribeToEvents()
    local function conditionalWrapper(handler)
        return function(...)
            if Mods.BG3MCM.MCMAPI:GetSettingValue("mod_enabled", ModuleUUID) then
                handler(...)
            else
                WIEGDebug(1, "Event handling is disabled.")
            end
        end
    end

    WIEGDebug(2,
        "Subscribing to events with JSON config: " ..
        Ext.Json.Stringify(Mods.BG3MCM.MCMAPI:GetAllModSettings(ModuleUUID), { Beautify = true }))

    Ext.Osiris.RegisterListener("TeleportToWaypoint", 2, "after", conditionalWrapper(EHandlers.OnTeleportToWaypoint))
    Ext.Osiris.RegisterListener("ReadyCheckFailed", 1, "after", conditionalWrapper(EHandlers.OnReadyCheckFailed))
end

return SubscribedEvents
