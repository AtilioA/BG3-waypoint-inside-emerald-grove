Teleporting = {}

Teleporting.EMERALD_GROVE_ENVIRONS_TRIGGER = "S_DEN_WaypointPos_cdd91969-67d0-454e-b27b-cf34e542956b"
Teleporting.destinations = {
  ['ARRON'] = { x = 201.95933532715, y = 27.75, z = 510.13491821289 },
  ['THE HOLLOW'] = { x = 188.07084655762, y = 19.72265625, z = 562.81359863281 },
  ['SACRED POOL'] = { x = 260.72442626953, y = 19.84765625, z = 540.83435058594 },
}

function GetDestinationCoordinates(destinationID)
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
  else
    Utils.DebugPrint(1, "Teleporting to Emerald Grove failed")
  end
end

function Teleporting.TeleportPartyMembersToCharacter(character)
  local x, y, z = Osi.GetPosition(character)
  if x and y and z then
    Utils.DebugPrint(1, "Teleporting party members to character: (" .. x .. ", " .. y .. ", " .. z .. ")")
    Osi.TeleportToPosition(character, x, y, z, "TeleportPartyMembersToCharacter_" .. character,
      1,
      1,
      1, 0, 1)
  else
    Utils.DebugPrint(1, "Teleporting party members to character failed")
  end
end

return Teleporting
