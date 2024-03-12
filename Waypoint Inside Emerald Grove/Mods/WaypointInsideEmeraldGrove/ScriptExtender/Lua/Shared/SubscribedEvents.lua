SubscribedEvents = {}

function SubscribedEvents.SubscribeToEvents()
  if Config:getCfg().GENERAL.enabled == true then
    WIEGDebug(2,
      "Subscribing to events with JSON config: " .. Ext.Json.Stringify(Config:getCfg(), { Beautify = true }))

    Ext.Osiris.RegisterListener("TeleportToWaypoint", 2, "after", EHandlers.OnTeleportToWaypoint)

    Ext.Osiris.RegisterListener("ReadyCheckFailed", 1, "after", EHandlers.OnReadyCheckFailed)
  end
end

return SubscribedEvents
