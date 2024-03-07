setmetatable(Mods.WaypointInsideEmeraldGrove, { __index = Mods.VolitionCabinet })

Ext.Require("Shared/Utils.lua")
Ext.Require("Shared/Helpers/String.lua")
-- Ext.Require("Shared/Helpers/Printer.lua")
Ext.Require("Shared/Config.lua")
Ext.Require("Shared/Teleporting.lua")
-- Ext.Require("Shared/Helpers/Inventory.lua")
Ext.Require("Shared/EventHandlers.lua")

MOD_UUID = "e342ee75-f7c9-4aeb-b6de-403991578337"
local MODVERSION = Ext.Mod.GetMod(MOD_UUID).Info.ModVersion

if MODVERSION == nil then
    VolitionCabinetPrinter:PrintDebug("loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    VolitionCabinetPrinter:PrintDebug("version " .. versionNumber .. " by Volitio loaded")
end

local EventSubscription = Ext.Require("Shared/SubscribedEvents.lua")
EventSubscription.SubscribeToEvents()
