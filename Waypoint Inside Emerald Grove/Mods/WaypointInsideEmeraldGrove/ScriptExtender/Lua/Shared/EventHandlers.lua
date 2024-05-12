EHandlers = {}

function EHandlers.OnLevelGameplayStarted(levelName, isEditorMode)
    if WaypointHandler:HasCharacterEverEnteredGrove(Osi.GetHostCharacter()) then
        WIEGDebug(1, "Character has entered grove at some point, trying to unlock custom waypoint")
        WaypointHandler:UnlockCustomEmeraldGroveWaypoint()
    end

    if WaypointHandler:HasRitualOfThornsBeenActivated(Osi.GetHostCharacter()) then
        WIEGDebug(1, "Ritual of Thorns has been activated, trying to lock custom waypoint")
        WaypointHandler:LockCustomEmeraldGroveWaypoint()
    end
end

function EHandlers.OnTeleportToWaypoint(character, trigger)
    WIEGDebug(2, "OnTeleportToWaypoint: " .. character .. " " .. trigger)
    WaypointHandlerInstance:HandleWaypointTrigger(character, trigger)

    WaypointHandlerInstance.regionSwapRejected = false
end

function EHandlers.OnReadyCheckFailed(id)
    -- Should be triggered even if the target isn't Environs, BUT it works, so...
    if id == "WaypointTravel_RegionSwap" then
        WIEGPrint(0, "Region swap was rejected, teleporting back to original position.")
        if WaypointHandlerInstance.originalPosition then
            local character, x, y, z = WaypointHandlerInstance.originalPosition.character,
                WaypointHandlerInstance.originalPosition.x,
                WaypointHandlerInstance.originalPosition.y, WaypointHandlerInstance.originalPosition.z
            Osi.TeleportToPosition(character, x, y, z, "TeleportBackAfterRefusedRegionSwap",
                1,
                1,
                1, 0, 1)
        end
    end
end

return EHandlers
