EHandlers = {}

-- Flag set when a character has entered The Hollow
EHandlers.HasEnteredGroveFlagGUID = "18cfaaeb-c0df-46ac-962d-0c300f816d73" -- DEN_General_State_EnteredCave
EHandlers.RitualOfThornsFlagGUID = "DEN_Lockdown_State_Active_0b54c7d2-b7b1-4d0f-b8e4-0cf1ee32b1eb"

function EHandlers.HasCharacterEverEnteredGrove(character)
  return Osi.GetFlag(EHandlers.HasEnteredGroveFlagGUID, character) == 1
end

function EHandlers.HasRitualOfThornsBeenActivated(character)
  return Osi.GetFlag(EHandlers.RitualOfThornsFlagGUID, character)
end

function EHandlers.OnTeleportToWaypoint(character, trigger)
  WIEGDebug(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
  TeleportHandlerInstance:HandleWaypointTrigger(character, trigger)

  TeleportHandlerInstance.regionSwapRejected = false
end

function EHandlers.OnReadyCheckFailed(id)
  -- Should be triggered even if the target isn't Environs, BUT it works, so...
  if id == "WaypointTravel_RegionSwap" then
    WIEGPrint(0, "Region swap was rejected, teleporting back to original position.")
    if TeleportHandlerInstance.originalPosition then
      local character, x, y, z = TeleportHandlerInstance.originalPosition.character,
          TeleportHandlerInstance.originalPosition.x,
          TeleportHandlerInstance.originalPosition.y, TeleportHandlerInstance.originalPosition.z
      Osi.TeleportToPosition(character, x, y, z, "TeleportBackAfterRefusedRegionSwap",
        1,
        1,
        1, 0, 1)
    end
  end
end

return EHandlers
