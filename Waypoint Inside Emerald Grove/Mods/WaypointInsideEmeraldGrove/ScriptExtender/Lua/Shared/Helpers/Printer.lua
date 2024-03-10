WIEGPrinter = VolitionCabinetPrinter:New { Prefix = "WIEG", ApplyColor = true, DebugLevel = Config:GetCurrentDebugLevel() }

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
