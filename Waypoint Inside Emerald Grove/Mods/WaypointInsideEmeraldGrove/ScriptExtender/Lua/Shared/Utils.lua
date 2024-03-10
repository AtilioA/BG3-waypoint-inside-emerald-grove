Utils = {}

function Utils.DebugPrint(level, ...)
  if Config:cfg() and Config:cfg().DEBUG and Config:cfg().DEBUG.level >= level then
    if (Config:cfg().DEBUG.level == 0) then
      print("[Waypoint Inside Emerald Grove]: " .. ...)
    else
      print("[Waypoint Inside Emerald Grove][D" .. level .. "]: " .. ...)
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

-- Courtesy of FallenStar/Fararagi (https://github.com/FallenStar08/)
---Delay a function call by the given time
---@param ms integer
---@param func function
function DelayedCall(ms, func)
  if ms == 0 then
    func()
    return
  end
  local Time = 0
  local handler
  handler = Ext.Events.Tick:Subscribe(function(e)
    Time = Time + e.Time.DeltaTime * 1000
    if (Time >= ms) then
      func()
      Ext.Events.Tick:Unsubscribe(handler)
    end
  end)
end

function Utils.IsSneaking(character)
  local characterEntity = Ext.Entity.Get(character)
  -- REVIEW: There's probably a better way to detect sneaking
  return characterEntity.SpellModificationContainer and characterEntity.SpellModificationContainer.Modifications and
      characterEntity.SpellModificationContainer.Modifications.Shout_Hide ~= nil
end

return Utils
