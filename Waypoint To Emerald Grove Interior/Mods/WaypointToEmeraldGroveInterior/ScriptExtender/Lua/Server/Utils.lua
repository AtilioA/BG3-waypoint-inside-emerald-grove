Utils = {}

function Utils.DebugPrint(level, ...)
  if JsonConfig and JsonConfig.DEBUG and JsonConfig.DEBUG.level >= level then
    if (JsonConfig.DEBUG.level == 0) then
      print("[Waypoint To Emerald Grove Interior]: " .. ...)
    else
      print("[Waypoint To Emerald Grove Interior][D" .. level .. "]: " .. ...)
    end
  end
end

-- Get the last 36 characters of the UUID (template ID)
function Utils.GetGUID(uuid)
  return string.sub(uuid, -36)
end

function Utils.GetPartyMembers()
  local teamMembers = {}

  local allPlayers = Osi.DB_Players:Get(nil)
  for _, player in ipairs(allPlayers) do
    if not string.match(player[1]:lower(), "%f[%A]dummy%f[%A]") then
      teamMembers[#teamMembers + 1] = Utils.GetGUID(player[1])
    end
  end

  return teamMembers
end

function Utils.DumpCharacterEntity(character)
  local charEntity = Ext.Entity.Get(character)
  Ext.IO.SaveFile('character-entity-WaypointToEmeraldGroveInterior.json', Ext.DumpExport(charEntity:GetAllComponents()))
end

return Utils
