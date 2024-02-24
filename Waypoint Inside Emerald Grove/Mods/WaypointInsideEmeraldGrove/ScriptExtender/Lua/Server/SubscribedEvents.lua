local function SubscribeToEvents()
  if JsonConfig.GENERAL.enabled == true then
    Utils.DebugPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(JsonConfig, { Beautify = true }))

    Ext.Osiris.RegisterListener("TeleportToWaypoint", 2, "after", EHandlers.OnTeleportToWaypoint)

    Ext.Osiris.RegisterListener("ReadyCheckFailed", 1, "after", EHandlers.OnReadyCheckFailed)
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
