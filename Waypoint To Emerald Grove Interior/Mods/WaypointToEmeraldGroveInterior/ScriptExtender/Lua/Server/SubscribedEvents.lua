local function SubscribeToEvents()
  if JsonConfig.GENERAL.enabled == true then
    Utils.DebugPrint(2, "Subscribing to events with JSON config: " .. Ext.Json.Stringify(JsonConfig, { Beautify = true }))

    Ext.Osiris.RegisterListener("TeleportToWaypoint", 2, "before", EHandlers.OnTeleportToWaypoint)
    Ext.Osiris.RegisterListener("GainedControl", 1, "after", function(target)
      DumpCharacterEntity(target)
    end)
    -- Ext.Osiris.RegisterListener("AutomatedDialogStarted", 2, "before", EHandlers.OnAutomatedDialogStarted)
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
