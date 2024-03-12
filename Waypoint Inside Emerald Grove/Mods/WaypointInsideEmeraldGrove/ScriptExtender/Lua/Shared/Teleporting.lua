---@class TeleportingHandler: MetaClass
---@field private VFX_Waypoint_Portal string -- The VFX identifier for the waypoint portal effect
---@field private destinations table -- A table mapping destination names to their coordinates
TeleportingHandler = _Class:Create("TeleportingHandler")

function TeleportingHandler:Init()
  self.EmeraldGroveEnvironsWaypointTrigger = "S_DEN_WaypointPos_cdd91969-67d0-454e-b27b-cf34e542956b"
  self.VFX_Waypoint_Portal = "f545f66c-87c8-8dde-cd27-16539cb0dc45"
  self.destinations = {
    ['ARRON'] = { x = 205.95933532715, y = 29.75, z = 505.13491821289 },
    ['THE HOLLOW'] = { x = 188.07084655762, y = 19.72265625, z = 562.81359863281 },
    ['SACRED POOL'] = { x = 260.72442626953, y = 19.84765625, z = 540.83435058594 },
  }
end

function TeleportingHandler:HandleWaypointTrigger(character, trigger)
  if trigger == TeleportHandlerInstance.EmeraldGroveEnvironsWaypointTrigger and ShouldTeleportToGrove(character) then
    TeleportHandlerInstance:TeleportToEmeraldGrove(character)
  end
end

function TeleportingHandler:GetDestinationCoordinates(destinationID)
  local destination = self.destinations[destinationID]
  if destination then
    return destination.x, destination.y, destination.z
  end
end

function TeleportingHandler:PlayDestinationEffect(destinationID)
  if destinationID == "THE HOLLOW" then
    Osi.PlayEffectAtPositionAndRotation(self.VFX_Waypoint_Portal, 190, 21, 562, 92, 1)
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
