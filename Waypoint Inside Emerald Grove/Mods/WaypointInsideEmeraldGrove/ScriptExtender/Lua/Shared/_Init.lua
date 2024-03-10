setmetatable(Mods.WaypointInsideEmeraldGrove, { __index = Mods.VolitionCabinet })

Ext.Require("Shared/Helpers/Config.lua")
Ext.Require("Shared/Helpers/Printer.lua")
Ext.Require("Shared/Utils.lua")
Ext.Require("Shared/Teleporting.lua")
-- Ext.Require("Shared/Helpers/Inventory.lua")
Ext.Require("Shared/EventHandlers.lua")

local MODVERSION = Ext.Mod.GetMod(ModuleUUID).Info.ModVersion


if MODVERSION == nil then
    WIEGWarn(0, "loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    WIEGPrint(0, "Waypoint Inside Emerald Grove version " .. versionNumber .. " loaded")
    WIEGPrint(2, "Config loaded: " .. Ext.Json.Stringify(Config:cfg(), { Beautify = true }))
end

local EventSubscription = Ext.Require("Shared/SubscribedEvents.lua")
EventSubscription.SubscribeToEvents()
