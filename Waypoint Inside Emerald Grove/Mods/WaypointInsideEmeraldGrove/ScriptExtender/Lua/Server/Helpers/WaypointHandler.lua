---@class WaypointHandler: MetaClass
---@field private EmeraldGroveEnvironsWaypointTrigger string -- The identifier for the waypoint trigger in the Emerald Grove environs
---@field private VFX_Waypoint_Portal string -- The VFX identifier for the waypoint portal effect
---@field private destinations table -- A table mapping destination names to their coordinates
---@field public originalPosition vec3 -- A vector containing the original position of the character
---@field public regionSwapRejected boolean -- A boolean indicating whether the region swap was rejected
WaypointHandler = _Class:Create("WaypointHandler")

WaypointHandler.EmeraldGroveHandle = "h0d3f4dc9g14d6g4389g9f48gb4f6acf4bc1e"
WaypointHandler.CustomEmeraldGroveWaypointID = "de94548d-03eb-4b5d-bf29-000b96f0dfe1"
WaypointHandler.CustomEmeraldGroveWaypointTrigger = "S_DEN_TheHollowWaypointPos_de94548d-03eb-4b5d-bf29-000b96f0dfe1"
WaypointHandler.EmeraldGroveEnvironsWaypointTrigger = "S_DEN_WaypointPos_cdd91969-67d0-454e-b27b-cf34e542956b"
WaypointHandler.VFX_Waypoint_Portal = "f545f66c-87c8-8dde-cd27-16539cb0dc45"
WaypointHandler.VFX_Waypoint_Portal_Loop = "ac49625c-c1fb-a34c-911c-d43e65164364"
WaypointHandler.destinations = {
    ['Arron'] = { x = 205.95933532715, y = 29.75, z = 505.13491821289 },
    ['The Hollow'] = { x = 188.07084655762, y = 19.72265625, z = 562.81359863281 },
    ['Sacred Pool'] = { x = 260.72442626953, y = 19.84765625, z = 540.83435058594 },
}
WaypointHandler.originalPosition = nil
WaypointHandler.regionSwapRejected = false

WaypointFlagsHandler = _Class:Create("WaypointFlagsHandler")

WaypointFlagsHandler.HasEnteredGroveFlagGUID = "18cfaaeb-c0df-46ac-962d-0c300f816d73"
WaypointFlagsHandler.RitualOfThornsFlagGUID = "DEN_Lockdown_State_Active_0b54c7d2-b7b1-4d0f-b8e4-0cf1ee32b1eb"
WaypointFlagsHandler.HasVisitedAct3Flag =
"VISITEDREGION_BGO_Main_A_40f06537-814f-4796-b012-5ffaa648a8d9"
WaypointFlagsHandler.HasReachedAct2PNR = "Act2_PointOfNoReturnReached_a3155f30-b8f3-4db5-ac21-d3036f4426e3"

function WaypointFlagsHandler:HasCharacterEverEnteredGrove(character)
    return Osi.GetFlag(WaypointFlagsHandler.HasEnteredGroveFlagGUID, character) == 1
end

function WaypointFlagsHandler:HasRitualOfThornsBeenActivated(character)
    return Osi.GetFlag(WaypointFlagsHandler.RitualOfThornsFlagGUID, character) == 1
end

function WaypointFlagsHandler:HasCharacterProgressedEnoughToDisableWaypoint(character)
    return Osi.GetFlag(WaypointFlagsHandler.HasVisitedAct3Flag, Osi.GetHostCharacter()) == 1 or
        Osi.GetFlag(WaypointFlagsHandler.HasReachedAct2PNR, Osi.GetHostCharacter()) == 1
end

--- Check if the character should be blocked from teleporting to the grove
---@param character GUIDSTRING The character to check against
---@return table blockageInfo A table containing blockage status and reason
function WaypointFlagsHandler:CheckWaypointBlockage(character)
    local reason = nil

    if not self:HasCharacterEverEnteredGrove(character) then
        reason = "Character has not entered grove yet"
    elseif self:HasRitualOfThornsBeenActivated(character) then
        reason = "Lockdown has happened"
    elseif self:HasCharacterProgressedEnoughToDisableWaypoint(character) then
        reason = "Character has entered Act 2 Point of No Return or Act 3"
    end

    local isBlocked = reason ~= nil

    return { isBlocked = isBlocked, reason = reason }
end

function WaypointHandler:UnlockCustomEmeraldGroveWaypoint()
    Osi.UnlockWaypoint(Ext.Loca.GetTranslatedString(WaypointHandler.EmeraldGroveHandle),
        WaypointHandler.CustomEmeraldGroveWaypointID,
        Osi.GetHostCharacter())
end

function WaypointHandler:LockCustomEmeraldGroveWaypoint()
    Osi.LockWaypoint(Ext.Loca.GetTranslatedString(WaypointHandler.EmeraldGroveHandle), Osi.GetHostCharacter())
    Osi.LockWaypoint("Emerald Grove", Osi.GetHostCharacter())
end

--- Check flags/DBs for whether the Grove lockdown has happened already
---@param character GUIDSTRING The character to check against (won't even be used for DB check)
function WaypointHandler:ShouldTeleportToGrove(character)
    local x, y, z = Osi.GetPosition(character)
    WaypointHandler.OriginalPosition = { character = character, x = x, y = y, z = z }

    local waypointBlockageInfo = WaypointFlagsHandler:CheckWaypointBlockage(character)
    if waypointBlockageInfo.isBlocked then
        WIEGPrint(1, "Not teleporting. Reason: " .. waypointBlockageInfo.reason)
        return false
    elseif WaypointHandler.RegionSwapRejected then
        WIEGPrint(2, "Region swap was rejected, shouldn't teleport to Grove.")
        return false
    else
        WIEGPrint(2,
            "Character has entered grove, lockdown has not happened, and character is not sneaking, teleporting")
        WaypointHandler.RegionSwapRejected = false
        return true
    end
end

function WaypointHandler:HandleWaypointTrigger(character, trigger)
    if trigger == WaypointHandler.CustomEmeraldGroveWaypointTrigger and self:ShouldTeleportToGrove(character) then
        WaypointHandlerInstance:TeleportToEmeraldGrove(character)
    end
end

function WaypointHandler:GetDestinationCoordinates(destinationID)
    local destination = WaypointHandler.destinations[destinationID]
    if destination then
        return destination.x, destination.y, destination.z
    end
end

function WaypointHandler:PlayDestinationEffect(destinationID)
    if destinationID == "The Hollow" then
        local fxHandle = Osi.PlayLoopEffectAtPositionAndRotation(WaypointHandler.VFX_Waypoint_Portal_Loop, 189.75, 21.5,
            561.9,
            40,
            92,
            0, 1)
        if fxHandle == nil then
            WIEGWarn(0, "Failed to play loop effect")
            return
        end
        -- Stop the looping effect after 2.5 seconds
        VCHelpers.Timer:OnTime(2500, function()
            Osi.StopLoopEffect(tonumber(fxHandle))
        end)
    elseif destinationID == "Arron" then
        Osi.PlayEffectAtPositionAndRotation(WaypointHandler.VFX_Waypoint_Portal, 206, 29.5, 505, 92, 1)
    end
end

function WaypointHandler:TeleportToEmeraldGrove(character)
    local destinationID = MCMGet("waypoint_destination")
    WIEGPrint(1, "Teleporting to Emerald Grove: (" .. destinationID .. ")")
    local x, y, z = self:GetDestinationCoordinates(destinationID)
    if x and y and z then
        Osi.TeleportToPosition(character, x, y, z, "TeleportToEmeraldGrove_" .. destinationID, 1, 1, 1, 0, 1)
        self:PlayDestinationEffect(destinationID)
    else
        WIEGWarn(0, "Teleporting to Emerald Grove failed")
    end
end

return WaypointHandler
