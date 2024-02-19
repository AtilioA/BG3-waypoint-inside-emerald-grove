EHandlers = {}

function EHandlers.OnTeleportToWaypoint(character, trigger)
  Utils.DebugPrint(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
end

return EHandlers
