EHandlers = {}

function EHandlers.OnTeleportToWaypoint(character, trigger)
  Utils.DebugPrint(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
  if trigger == Teleporting.EMERALD_GROVE_ENVIRONS_TRIGGER then
    Utils.DebugPrint(1, "Teleporting to Emerald Grove")
    DelayedCall(100, function()
      Teleporting.TeleportToTheHollow(character)
    end)
  end
end

return EHandlers
