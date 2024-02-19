EHandlers = {}

function EHandlers.OnTeleportToWaypoint(character, trigger)
  Utils.DebugPrint(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
  if trigger == Teleporting.EMERALD_GROVE_ENVIRONS_TRIGGER then
    if JsonConfig.FEATURES.original_waypoint_if_sneaking and IsSneaking(character) then
      Utils.DebugPrint(1, "Player is sneaking, using original waypoint")
      return
    else
      Utils.DebugPrint(1, "Teleporting to Emerald Grove")
      DelayedCall(100, function()
        Teleporting.TeleportToTheHollow(character)
      end)
    end
  end
end

return EHandlers
