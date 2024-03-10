CurrentTime = 0

local function SubscribeToEvents()
  if Config:getCfg().GENERAL.enabled == true then
    Utils.DebugPrint(2,
      "Subscribing to events with JSON config: " .. Ext.Json.Stringify(Config:getCfg(), { Beautify = true }))

    Ext.Osiris.RegisterListener("UseStarted", 2, "after", function(character, item)
      if (Osi.IsInPartyWith(character, Osi.GetHostCharacter()) == 1) then
        Utils.DebugPrint(2, "UseStarted: " .. character .. " " .. item)
        if string.find(item, "Elevator") then
          Utils.DumpObjectEntity(item, "Elevator")
          Teleporting.TeleportPartyMembersToCharacter(character)
        end
      end
    end)

    Ext.Osiris.RegisterListener("TeleportToWaypoint", 2, "after", EHandlers.OnTeleportToWaypoint)

    Ext.Osiris.RegisterListener("ReadyCheckFailed", 1, "after", EHandlers.OnReadyCheckFailed)

    Ext.Osiris.RegisterListener("TimerFinished", 1, "after", function(timer)
      if timer == "JumpTimer" then
        local timeDiff = Ext.Utils.MonotonicTime() - CurrentTime
        if timeDiff > 15000 then
          return
        elseif timeDiff > 2000 then
          Utils.DebugPrint(2, "JumpTimer: " .. timeDiff)
          Osi.ApplyStatus("HalfElves_Male_High_Player_Dev_76bf311a-d784-5261-fb0f-f335f5c598ce",
            "POTION_OF_STRENGTH_HILL_GIANT", 12, 100, "100")
          -- Osi.ApplyStatus("HalfElves_Male_High_Player_Dev_76bf311a-d784-5261-fb0f-f335f5c598ce", "LONG_JUMP", 120,
          -- 100, "100")

          -- Teleporting.TeleportPartyMembersToCharacter(Osi.GetHostCharacter())
        end
      end
    end)

    Ext.Osiris.RegisterListener("CastedSpell", 5, "after",
      function(caster, spell, spellType, spellElement, storyActionID)
        -- Utils.DebugPrint(2,
        -- "CastedSpell: " .. spell .. " " .. spellElement .. " " .. storyActionID .. " " .. caster .. " " .. spellType)
        if spell == "Projectile_Jump" then
          CurrentTime = Ext.Utils.MonotonicTime()
          Osi.TimerLaunch("JumpTimer", 2000)
        end
      end)
  end
end

return {
  SubscribeToEvents = SubscribeToEvents
}
