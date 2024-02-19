Ext.Require("Server/Utils.lua")
Ext.Require("Server/Config.lua")
Ext.Require("Server/Teleporting.lua")
-- Ext.Require("Server/Helpers/Inventory.lua")
Ext.Require("Server/EventHandlers.lua")

MOD_UUID = "e342ee75-f7c9-4aeb-b6de-403991578337"
local MODVERSION = Ext.Mod.GetMod(MOD_UUID).Info.ModVersion

if MODVERSION == nil then
    Utils.DebugPrint(0, "loaded (version unknown)")
else
    -- Remove the last element (build/revision number) from the MODVERSION table
    table.remove(MODVERSION)

    local versionNumber = table.concat(MODVERSION, ".")
    Utils.DebugPrint(0, "version " .. versionNumber .. " loaded")
end

local EventSubscription = Ext.Require("Server/SubscribedEvents.lua")
EventSubscription.SubscribeToEvents()
