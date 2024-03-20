---@class TeleportingHandler: MetaClass
---@field private EmeraldGroveEnvironsWaypointTrigger string -- The identifier for the waypoint trigger in the Emerald Grove environs
---@field private VFX_Waypoint_Portal string -- The VFX identifier for the waypoint portal effect
---@field private destinations table -- A table mapping destination names to their coordinates
---@field public originalPosition vec3 -- A vector containing the original position of the character
---@field public regionSwapRejected boolean -- A boolean indicating whether the region swap was rejected
TeleportingHandler = _Class:Create("TeleportingHandler")

function TeleportingHandler:Init()
  self.EmeraldGroveEnvironsWaypointTrigger = "S_DEN_WaypointPos_cdd91969-67d0-454e-b27b-cf34e542956b"
  self.VFX_Waypoint_Portal = "f545f66c-87c8-8dde-cd27-16539cb0dc45"
  self.VFX_Waypoint_Portal_Loop = "ac49625c-c1fb-a34c-911c-d43e65164364"
  self.destinations = {
    ['ARRON'] = { x = 205.95933532715, y = 29.75, z = 505.13491821289 },
    ['THE HOLLOW'] = { x = 188.07084655762, y = 19.72265625, z = 562.81359863281 },
    ['SACRED POOL'] = { x = 260.72442626953, y = 19.84765625, z = 540.83435058594 },
  }
  self.originalPosition = nil
  self.regionSwapRejected = false
end

--- Check flags/DBs for whether the Grove lockdown has happened already
---@param character GUIDSTRING The character to check against (won't even be used for DB check)
function ShouldFlagsBlockTeleport(character)
  local reason = ""
  if EHandlers.HasCharacterEverEnteredGrove(character) == 0 then
    reason = "Character has not entered grove yet"
  elseif EHandlers.HasRitualOfThornsBeenActivated(character) == 1 then
    reason = "Lockdown has happened"
  end

  return EHandlers.HasCharacterEverEnteredGrove(character) == 0 or
      EHandlers.HasRitualOfThornsBeenActivated(character) == 1, reason
end

function TeleportingHandler:ShouldTeleportToGrove(character)
  local x, y, z = Osi.GetPosition(character)
  TeleportingHandler.OriginalPosition = { character = character, x = x, y = y, z = z }

  local shouldSneakingKeepDestination = Config:getCfg().FEATURES.original_waypoint_if_sneaking and
      VCHelpers.Character:IsSneaking(character)
  local shouldBlockTeleporting, reason = ShouldFlagsBlockTeleport(character)
  if shouldBlockTeleporting or shouldSneakingKeepDestination then
    if shouldSneakingKeepDestination then
      reason = "Character is sneaking"
    end

    WIEGPrint(1, "Not teleporting. Reason: " .. reason)
    return false
  elseif TeleportingHandler.RegionSwapRejected then
    return false
  else
    WIEGPrint(2,
      "Character has entered grove, lockdown has not happened, and character is not sneaking, teleporting")
    TeleportingHandler.RegionSwapRejected = false
    return true
  end
end

function TeleportingHandler:HandleWaypointTrigger(character, trigger)
  if trigger == TeleportHandlerInstance.EmeraldGroveEnvironsWaypointTrigger and self:ShouldTeleportToGrove(character) then
    TeleportHandlerInstance:TeleportToEmeraldGrove(character)
  end
end

function TeleportingHandler:GetDestinationCoordinates(destinationID)
  local destination = self.destinations[destinationID]
  if destination then
    return destination.x, destination.y, destination.z
  end
end

--[[ TODO: Refactor to use this function
  function Osi.PlayLoopEffectAtPositionAndRotation(fxName, x, y, z, xAngle, yAngle, zAngle, scale) end
  Get the return value of this function and store it in a variable. Then use that variable to stop the effect.
  function Osi.StopEffect(fxHandle)
  Try to detect when the character is teleported and game has "loaded"? and then stop the effect. Or just stop it after ~2 seconds.
  ]]
function TeleportingHandler:PlayDestinationEffect(destinationID)
  if destinationID == "THE HOLLOW" then
    local fxHandle = Osi.PlayLoopEffectAtPositionAndRotation(self.VFX_Waypoint_Portal_Loop, 189.75, 21.5, 561.9,
      40,
      92,
      0, 1)
    if fxHandle == nil then
      WIEGWarn(0, "Failed to play loop effect")
      return
    end
    -- Stop the looping effect after 2.5 seconds
    VCHelpers.Timer:OnTime(2750, function()
      Osi.StopLoopEffect(tonumber(fxHandle))
    end)
  elseif destinationID == "ARRON" then
    Osi.PlayEffectAtPositionAndRotation(self.VFX_Waypoint_Portal, 206, 29.5, 505, 92, 1)
  end
end

function TeleportingHandler:TeleportToEmeraldGrove(character)
  local destinationID = Config:getCfg().FEATURES.new_waypoint_destination
  WIEGPrint(1, "Teleporting to Emerald Grove: (" .. destinationID .. ")")
  local x, y, z = self:GetDestinationCoordinates(destinationID)
  if x and y and z then
    Osi.TeleportToPosition(character, x, y, z, "TeleportToEmeraldGrove_" .. destinationID, 1, 1, 1, 0, 1)
    self:PlayDestinationEffect(destinationID)
  else
    WIEGWarn(0, "Teleporting to Emerald Grove failed")
  end
end

return TeleportingHandler
