EHandlers = {}

-- Flag set when a character has entered The Hollow
EHandlers.HasEnteredGroveFlagGUID = "18cfaaeb-c0df-46ac-962d-0c300f816d73" -- DEN_General_State_EnteredCave

function HasCharacterEverEnteredGrove(character)
  return Osi.GetFlag(EHandlers.HasEnteredGroveFlagGUID, character) == 1
end

function ShouldTeleportToGrove(character)
  local shouldSneakingKeepDestination = JsonConfig.FEATURES.original_waypoint_if_sneaking and Utils.IsSneaking(character)
  if not HasCharacterEverEnteredGrove(character) and not shouldSneakingKeepDestination then
    Utils.DebugPrint(1, "Character has not entered grove yet or is sneaking, not teleporting")
    return false
  end
end

function EHandlers.OnTeleportToWaypoint(character, trigger)
  Utils.DebugPrint(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
  if trigger == Teleporting.EMERALD_GROVE_ENVIRONS_TRIGGER and ShouldTeleportToGrove(character) then
    Utils.DebugPrint(1, "Teleporting to Emerald Grove")
    DelayedCall(100, function()
      Teleporting.TeleportToEmeraldGrove(character)
    end)
  end
end

return EHandlers
