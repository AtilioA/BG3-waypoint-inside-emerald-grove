Teleporting = {}

local VFX_Waypoint_Portal = "f545f66c-87c8-8dde-cd27-16539cb0dc45"

Teleporting.EMERALD_GROVE_ENVIRONS_TRIGGER = "S_DEN_WaypointPos_cdd91969-67d0-454e-b27b-cf34e542956b"
Teleporting.destinations = {
  ['ARRON'] = { x = 205.95933532715, y = 29.75, z = 505.13491821289 },
  ['THE HOLLOW'] = { x = 188.07084655762, y = 19.72265625, z = 562.81359863281 },
  ['SACRED POOL'] = { x = 260.72442626953, y = 19.84765625, z = 540.83435058594 },
}

local function PlayDestinationEffect(destinationID)
  if destinationID == "ARRON" then
    Osi.PlayEffectAtPositionAndRotation(VFX_Waypoint_Portal, 206, 29.5, 505, 92, 1)
  elseif destinationID == "THE HOLLOW" then
    Osi.PlayEffectAtPositionAndRotation(VFX_Waypoint_Portal, 190, 21, 562, 92, 1)
  end
end

local function GetDestinationCoordinates(destinationID)
  return Teleporting.destinations[destinationID].x, Teleporting.destinations[destinationID].y,
      Teleporting.destinations[destinationID].z
end

function Teleporting.TeleportToEmeraldGrove(character)
  local destinationID = Config:getCfg().FEATURES.new_waypoint_destination
  Utils.DebugPrint(1, "Teleporting to Emerald Grove: (" .. destinationID .. ")")
  local x, y, z = GetDestinationCoordinates(destinationID)
  if x and y and z then
    Osi.TeleportToPosition(character, x, y, z, "TeleportToEmeraldGrove_" .. destinationID,
      1,
      1,
      1, 0, 1)
    PlayDestinationEffect(destinationID)
  else
    Utils.DebugPrint(1, "Teleporting to Emerald Grove failed")
  end
end

return Teleporting
