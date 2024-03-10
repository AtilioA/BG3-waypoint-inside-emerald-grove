EHandlers = {}

-- Flag set when a character has entered The Hollow
EHandlers.HasEnteredGroveFlagGUID = "18cfaaeb-c0df-46ac-962d-0c300f816d73" -- DEN_General_State_EnteredCave

-- Avoid teleporting/teleport back if the region swap was rejected
EHandlers.RegionSwapRejected = false
EHandlers.OriginalPosition = nil

function HasCharacterEverEnteredGrove(character)
  return Osi.GetFlag(EHandlers.HasEnteredGroveFlagGUID, character) == 1
end

function HasRitualOfThornsBeenActivated(character)
  return Osi.GetFlag("DEN_Lockdown_State_Active_0b54c7d2-b7b1-4d0f-b8e4-0cf1ee32b1eb", character)
end

--- Check flags/DBs for whether the Grove lockdown has happened already
---@param character GUIDSTRING The character to check against (won't even be used for DB check)
function ShouldFlagsBlockTeleport(character)
  local reason = ""
  if HasCharacterEverEnteredGrove(character) == 0 then
    reason = "Character has not entered grove yet"
  elseif HasRitualOfThornsBeenActivated(character) == 1 then
    reason = "Lockdown has happened"
  end

  return HasCharacterEverEnteredGrove(character) == 0 or HasRitualOfThornsBeenActivated(character) == 1, reason
end

function ShouldTeleportToGrove(character)
  local x, y, z = Osi.GetPosition(character)
  EHandlers.OriginalPosition = { character = character, x = x, y = y, z = z }

  local shouldSneakingKeepDestination = Config:getCfg().FEATURES.original_waypoint_if_sneaking and
  Utils.IsSneaking(character)
  local shouldBlockTeleporting, reason = ShouldFlagsBlockTeleport(character)
  if shouldBlockTeleporting or shouldSneakingKeepDestination then
    if shouldSneakingKeepDestination then
      reason = "Character is sneaking"
    end

    Utils.DebugPrint(2, "Not teleporting. Reason: " .. reason)
    return false
  elseif EHandlers.RegionSwapRejected then
    return false
  else
    Utils.DebugPrint(2,
      "Character has entered grove, lockdown has not happened, and character is not sneaking, teleporting")
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
