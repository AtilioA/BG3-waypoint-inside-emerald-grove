WIEGPrinter = VolitionCabinetPrinter:New { Prefix = "Waypoint Inside Emerald Grove", ApplyColor = true, DebugLevel = MCMGet("debug_level") }

-- Update the Printer debug level when the setting is changed, since the value is only used during the object's creation
Ext.ModEvents["BG3MCM"]["MCM_Setting_Saved"]:Subscribe(function(payload)
    if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
        return
    end

    if payload.settingId == "debug_level" then
        WIEGDebug(0, "Setting debug level to " .. payload.value)
        WIEGPrinter.DebugLevel = payload.value
    end
end)

function WIEGPrint(debugLevel, ...)
    WIEGPrinter:SetFontColor(0, 255, 255)
    WIEGPrinter:Print(debugLevel, ...)
end

function WIEGTest(debugLevel, ...)
    WIEGPrinter:SetFontColor(100, 200, 150)
    WIEGPrinter:PrintTest(debugLevel, ...)
end

function WIEGDebug(debugLevel, ...)
    WIEGPrinter:SetFontColor(200, 200, 0)
    WIEGPrinter:PrintDebug(debugLevel, ...)
end

function WIEGWarn(debugLevel, ...)
    WIEGPrinter:SetFontColor(255, 100, 50)
    WIEGPrinter:PrintWarning(debugLevel, ...)
end

function WIEGDump(debugLevel, ...)
    WIEGPrinter:SetFontColor(190, 150, 225)
    WIEGPrinter:Dump(debugLevel, ...)
end

function WIEGDumpArray(debugLevel, ...)
    WIEGPrinter:DumpArray(debugLevel, ...)
end
