EHandlers = {}

-- Flag set when a character has entered The Hollow
EHandlers.HasEnteredGroveFlagGUID = "18cfaaeb-c0df-46ac-962d-0c300f816d73" -- DEN_General_State_EnteredCave
-- Avoid teleporting/teleport back if the region swap was rejected
EHandlers.RegionSwapRejected = false
EHandlers.OriginalPosition = nil

function HasCharacterEverEnteredGrove(character)
  return Osi.GetFlag(EHandlers.HasEnteredGroveFlagGUID, character) == 1
end

function ShouldTeleportToGrove(character)
  local x, y, z = Osi.GetPosition(character)
  EHandlers.OriginalPosition = { character = character, x = x, y = y, z = z }

  local shouldSneakingKeepDestination = JsonConfig.FEATURES.original_waypoint_if_sneaking and Utils.IsSneaking(character)
  if not HasCharacterEverEnteredGrove(character) or shouldSneakingKeepDestination then
    Utils.DebugPrint(2, "Character has not entered grove yet or is sneaking, not teleporting")
    return false
  elseif EHandlers.RegionSwapRejected then
    return false
  else
    Utils.DebugPrint(2, "Character has entered grove or is not sneaking, teleporting")
    EHandlers.RegionSwapRejected = false
    return true
  end
end

function EHandlers.OnTeleportToWaypoint(character, trigger)
  Utils.DebugPrint(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
  if trigger == Teleporting.EMERALD_GROVE_ENVIRONS_TRIGGER and ShouldTeleportToGrove(character) then
    DelayedCall(100, function()
      Teleporting.TeleportToEmeraldGrove(character)
    end)
  end

  EHandlers.RegionSwapRejected = false
end

function EHandlers.OnReadyCheckFailed(id)
  -- Should be triggered even if the target isn't Environs, BUT it works, so...
  if id == "WaypointTravel_RegionSwap" then
    Utils.DebugPrint(1, "Region swap was rejected, teleporting back to original position.")
    if EHandlers.OriginalPosition then
      local character, x, y, z = EHandlers.OriginalPosition.character, EHandlers.OriginalPosition.x,
          EHandlers.OriginalPosition.y, EHandlers.OriginalPosition.z
      Osi.TeleportToPosition(character, x, y, z, "TeleportBackAfterRefusedRegionSwap",
        1,
        1,
        1, 0, 1)
    end
  end
end

return EHandlers
